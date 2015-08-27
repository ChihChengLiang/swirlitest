test_lesson <- function(lesson_dir) {
    library(yaml)
    library(swirl)
    print(paste("####Begin testing", lesson_dir))
    e <- new.env()
    # Since the initLesson might change working directory, load lesson yaml first before that
    # happens.
    lesson <- yaml::yaml.load_file(file.path(lesson_dir, "lesson.yaml"))
    for (R_file in c("customTests.R", "initLesson.R")) {
        R_file_path <- file.path(lesson_dir, R_file)
        if (file.exists(R_file_path)) {
            source(R_file_path, local = e)
        }
    }
    for (question in lesson) {
        if (question["Class"] == "cmd_question") {
            if (!is.null(question["CorrectAnswer"])) {
                print(paste(">", question["CorrectAnswer"]))
                eval(parse(text = question["CorrectAnswer"]), envir = e)
            }
        } else if (question["Class"] == "script") {
            l <- strsplit(question$Script, "[.]")[[1]]
            correct_script_name <- paste0(l[1], "-correct.", l[2])
            correct_script_path <- file.path(lesson_dir, correct_script_name)
            if (file.exists(correct_script_path)) {
                try(source(correct_script_path))
            }
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

test_course_name <- function(course_name) {
    f <- file.path(swirl::get_swirl_option("courses_dir"), course_name)
    test_course_dir(f)
}

installed_courses <- function() {
    path <- swirl::get_swirl_option("courses_dir")
    list.dirs(path, recursive = F, full.names = F)
}
