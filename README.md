# swirlitest

Test all lessons of a swirl course. Automatically testing for a large course can't be more easier.

## Installation

```{r}
library(devtools)
devtools::install_github(repo = "ChihChengLiang/swirlitest")
```



## Usage

```{r}
library(swirlitest)
test_course_dir("path_to_your_swirl_course")
```

The function runs through all your CorrectAnswers of cmd_questions of all lessons of your course.

If something goes wrong, you expect to see an error message ASAP.


## Example

This example test the course of https://github.com/TaiwanRUserGroup/DSC2015Tutorial

```{r}
source("http://taiwanrusergroup.github.io/R/init.R")
swirl::uninstall_all_courses()
DSC2015R::install_course()
library(swirlitest)
test_course_name( "DSC2015")
```

