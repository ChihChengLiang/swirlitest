test_lesson <- function(lesson_dir) {
    library(yaml)
    library(swirl)
    print(paste("####Begin testing", lesson_dir))
    e <- new.env()
    # Since the initLesson might change working directory,
    # load lesson yaml first before that happens.
    lesson <- yaml::yaml.load_file(file.path(lesson_dir, "lesson.yaml"))
    for (R_file in c("customTests.R", "initLesson.R")) {
        R_file_path <- file.path(lesson_dir, R_file)
        if (file.exists(R_file_path))
            source(R_file_path, local = e)
    }
    for (question in lesson) {
        if (!is.null(question["CorrectAnswer"]) &&
              question["Class"] == "cmd_question") {
            print(paste(">", question["CorrectAnswer"]))
            eval(parse(text = question["CorrectAnswer"]), envir = e)
        }
    }
    print(paste("-----Testing", lesson_dir, "Done"))
    session <- sessionInfo()
    for (pkg in session$otherPkgs) {
        pkg_name <- paste0("package:", pkg$Package)
        print(pkg_name)
        detach(pkg_name, character.only = TRUE, unload = TRUE)
    }
}

test_course_dir <- function(course_dir) {
    paths <- list.dirs(course_dir, recursive = F)
    wd <- getwd()
    for (path in paths) {
        setwd(wd)
        test_lesson(path)
    }
    setwd(wd)
} 

test_course_name <- function(course_name){
  f = file.path(get_swirl_option("courses_dir"), course_name)
  test_course_dir(f)
}