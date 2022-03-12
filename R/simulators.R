create_client <- function() {
  gender <- sample(c("male", "female"), 1, prob = c(.4, .6))
  tibble::tibble(client_id = paste0(sample(0:9, 8), collapse = ""),
         first_name = randomNames::randomNames(1,
                                               gender = ifelse(gender == "male", 0, 1),
                                               which.names = "first"),
         last_name = randomNames::randomNames(1, which.names = "last"),
         dob = wakefield::dob(1, start = Sys.Date() - 365 * 20),
         gender = gender,
         cisgender_flag = sample(c(TRUE, FALSE), 1, prob = c(.9, .1)),
         atsi_flag = sample(c(TRUE, FALSE), 1, prob = c(.1, .9)),
         homeless_flag = sample(c(TRUE, FALSE), 1, prob = c(.05, .95)),
         translator_required = sample(c(TRUE, FALSE), 1, prob = c(.05, .95)),
         home_language = wakefield::language(1)

  )
}


create_contact <-  function(client_id) {
  dist <- dnorm(1:181, mean = 2*12, sd = 36) + dnorm(1:181, mean = 15*12, sd = 36)
  dist <- dist/sum(dist)

  tibble(client_id = client_id,
         contact_id = paste0(sample(0:9, 8), collapse = ""),
         contact_date = wakefield::date_stamp(1, start = Sys.Date() - months(24)),
         contact_time = wakefield::time_stamp(1, x = seq(7, 22, by = 5/60), prob = dist))

}

create_contacts <- function(df){
  i <- rep(df$client_id, times = rpois(length(df$client_id), lambda = 3))
  purrr::map_df(i, create_contact)

}

localise_clients <- function(contacts) {
  idx <- contacts %>% distinct(client_id) %>%
    mutate(service_location = sample(c("Agloe", "Argleton", "Mawdesky", "Bielefeld"),
                                     n(), replace = TRUE)
    )
  contacts %>% left_join(idx, by = "client_id")
}

create_intakes <- function(contacts){

    rows <- length(unique(contacts$client_id))

  contacts %>%
    group_by(client_id) %>%
    slice(1) %>%
    ungroup() %>%
    select(-service_location) %>%
    rename(measure_date = contact_date,
      measure_time = contact_time) %>%
    mutate(iar_level = sample(1:5, rows,
                         prob = dbinom(0:4, size = 4, prob = .5),
                         replace = TRUE),
           presenting_concern = sample(c("Anxiety", "Depression", "AOD", "Burnout", "Insufficient cats"),
                                       size = rows, prob = c(.3, .3, .2, .19, .01), replace = TRUE)
    )
}

df <- purrr::rerun(20, create_client()) %>% do.call(rbind.data.frame, .) %>%
  distinct(client_id, .keep_all = TRUE)

contacts <-  create_contacts(df) %>% localise_clients()

create_intakes(contacts)

