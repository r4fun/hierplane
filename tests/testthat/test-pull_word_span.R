test_that("Single occurence - word", {

  # single occurence - word
  txt <- "i like cats"
  word_id <- 3 # cats
  expect_output <- list(start = 8 - 1, # conform to js indexing
                        end = 11)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)
})

test_that("Multiple occurences - word", {
  txt <- "cats cat cats cat cats"
  word_id <- 3
  expect_output <- list(start = 10 - 1, # conform to js indexing
                        end = 13)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)
})

test_that("Make sure different subset of the words does not impact pull" ,{

  txt <- "cats cat cats cat cats"
  word_id <- 4
  expect_output <- list(start = 15 - 1, # conform to js indexing
                        end = 17)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)

})

test_that("Capitalization does not impact pull" ,{

  txt <- "Cat CAT CaT cAt"
  word_id <- 3
  expect_output <- list(start = 9 - 1, # conform to js indexing
                        end = 11)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)

})

test_that("Single occurence - symbol", {
  txt <- "i like cats."

  word_id <- 4
  expect_output <- list(start = 12 - 1, # conform to js indexing
                        end = 12)

  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)

})

test_that("Multiple occurences - symbol", {
  # multiple occurence - punctuation
  txt <- "tylurp just completed a $2,000,000 transaction addressed to nigerian.prince@notscam.com. "
  word_id <- 11
  expect_output <- list(start = 88 - 1, # conform to js indexing
                        end = 88)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)
})


test_that("Works for 1 word input", {
  txt <- "cats"
  word_id <- 1
  expect_output <- list(start = 1 - 1, # conform to js indexing
                        end = 4)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)

})


test_that("Works for pulling first word", {
  txt <- "cats are cute"
  word_id <- 1
  expect_output <- list(start = 1 - 1, # conform to js indexing
                        end = 4)
  test_output <- pull_word_span(txt, word_id)
  expect_equal(test_output, expect_output)

})
