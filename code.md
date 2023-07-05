Dr. Kelly Sovacool's thoughts on  general guidelines for organization, quality, & formatting standards. Sources: Dr. Pat Schloss, Software Carpentry, and the US Research Software Sustainability Institute (URSSI). 

# Directory organization.
Every project or package should have its own self-contained directory which is also a git repo. 
For projects that become manuscripts, you're probably using Snakemake or another workflow manager (e.g. nextflow, make, cromwell). The top level directory should be named AuthorLastname_ProjectTitleSlug_Journal_Year. For example, one of my papers was about benchmarking an algorithm called OptiFit, and we published it in the ASM journal mSphere, so I named the repo Sovacool_OptiFit_mSphere_2022. While working on the project I just used the name "OptiFit" because I didn't know where & when it would be published. You can always rename the directory & corresponding github repo if the journal/year/etc changes. Use something like this structure to organize your files:
```
.
├── LICENSE.md
├── README.md
├── config
│   ├── README.md
│   ├── default.yml
│   ├── slurm
│   │   └── config.yaml
│   └── test.yml
├── data
│   ├── SRR_Acc_List.txt
│   ├── SraRunTable.csv
│   ├── process
│   │   └── table.csv
│   └── raw
│       └── SRAXXXX.fastq.gz
├── figures
│   └── figure-1_ml-results.tiff
├── paper
│   ├── header.tex
│   ├── mbio.csl
│   ├── paper.Rmd
│   ├── paper.pdf
│   └── references.bib
├── results
│   └── feature_importance_results_aggregated.csv
├── tests
│   ├── testthat
│   │   └── test-train_models.R
│   ├── test_python.py
│   └── testthat.R
└── workflow
    ├── Snakefile
    ├── documentation.md
    ├── envs
    │   └── mothur.yml
    ├── notebooks
    │   ├── asm-microbe-2022
    │   ├── exploratory.Rmd
    │   ├── preliminary_2022-04.Rmd
    │   └── preliminary_2022-04.md
    ├── rules
    │   ├── machine_learning.smk
    │   └── plot_figures.smk
    └── scripts
        ├── count_reads.py
        ├── train_models.R
        ├── count_reads.py
        ├── slurm
        │   └── submit.sh
        └── utilities.R
```

For projects that become software packages, you have to adhere to either CRAN or PyPI's guidelines on directory structure.
* R packages: follow Hadley Wickham & Jenny Bryan's book like it's the Bible: https://r-pkgs.org/index.html
* Python packages: see my notes and relevant links on this page from the URSSI winter school: https://sovacool.dev/posts/2019-12-19-urssi-winterschool-notes/

# Testing
* Write unit tests for every function. My notes from URSSI and the R Packages book (both linked above) have good testing guidelines. I haven't done a great job of testing my code for manuscripts exhaustively, but it's a good idea to do especially when you write a tricky function to make sure it actually works the way you think it does. Testing is especially important when you're writing software packages for others to use.
* Package for R: testthat
* Package for Python: unittest

# Code style
*There are lots of different style guides for various languages. The most important thing is to pick one and stick to it consistently.
* I like the Tidyverse Style Guide. I use most of their conventions for not only R but also Python code. https://style.tidyverse.org/

# Formatting
* Use a tool to format your code.
  * For R: styler
  * For Python: black
* Use github actions to automatically format & test your code when you push or open a PR. https://github.com/SchlossLab/Sovacool_OptiFit_mSphere_2022/blob/main/.github/workflows/build.yml

# Documentation
* Document every function and class. Describe parameters/arguments, return values, and any tricky behavior. Following a particular format makes it easy for software tools to automatically generate doc websites from your code.
* For R: use roxygen2 & pkgdown to generate docs. RStudio can insert a "roxygen skeleton" for you when you have a function defined. 
Example:
```
#' Replace spaces in all elements of a character vector with underscores
#'
#' @param x a character vector
#' @param new_char the character to replace spaces (default: `_`)
#'
#' @return character vector with all spaces replaced with `new_char`
#' @export
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' dat <- data.frame(
#'   dx = c("outcome 1", "outcome 2", "outcome 1"),
#'   a = 1:3, b = c(5, 7, 1)
#' )
#' dat$dx <- replace_spaces(dat$dx)
#' dat
replace_spaces <- function(x, new_char = "_") {
  if (is.character(x)) {
    x <- gsub(" ", new_char, x)
  }
  return(x)
}
```
How this function looks on the docs website: http://www.schlosslab.org/mikropml/reference/replace_spaces.html
For Python: use sphinx & readthedocs to generate docs. The PyCharm IDE can insert a function doc outline for you. Example:
```def write_pickle(filename, obj, overwrite=True):
    """
    Encode object into json pickle, then open filename and write to file in sorted, human-readable json.
    :param filename: name of pickle file to be written.
    :param obj: object to pickle.
    :param overwrite: if true will overwrite an existing file, if false will append to existing file.
    :return: None
    """
    jsonpickle.set_encoder_options('json', sort_keys=True, indent=2)
    mode = 'w' if overwrite else 'a'Code organization, quality, & formatting standards
    with open(filename, mode) as file:
        file.write(jsonpickle.encode(obj))
```

# Version control
Ideally you will use git & GitHub with a separate repo for each project. As long as you frequently commit and push your code to GitHub, you're covered in the event of overwriting your files or disk failure. If you give your commits good descriptive names, it makes life easier for you in the event you need to go back to a prior commit. You likely will not commit raw data to GitHub as those files are typically too large and often have private health information (PHI). You could commit intermediate and final results files if they're < 50 MB and only descriptive summary statistics (not indiviudal level data). Raw data should never be altered and should be backed up on some redundant computing system as able.

Resources:
[Software Carpentry Git & GitHub lesson](https://umcarpentries.org/intro-curriculum-r/03-intro-git-github/index.html)
Pat Schloss' [tutorial on organizing projects for reproducibility](https://riffomonas.org/reproducible_research/) (Skip the lesson on Make and use Snakemake instead) 


# Code review
* Keep the main branch of your repo as a clean, tested, documented, public-facing version of the codebase. When you want to make changes like fix a bug or implement a new feature, create a separate branch, commit your changes, then open a pull request and ask someone else to review your code. They can suggest changes and give you feedback for you to implement before approving the changes and merging the PR into the main branch.
* It may not make sense to do this for every little change when you're just getting started on a project. You might prefer to sit down with someone to review your code together once you have a solid codebase written.
* More on collaborating with github here: https://sovacool.dev/posts/2019-12-19-urssi-winterschool-notes/#collaboration-with-git-and-github-karthik-ram

# Relevant papers:
Wilson G, Aruliah DA, Brown CT, Chue Hong NP, Davis M, Guy RT, Haddock SHD, Huff KD, Mitchell IM, Plumbley MD, Waugh B, White EP, Wilson P. 2014. Best Practices for Scientific Computing. PLoS Biol 12:e1001745.
Wilson G, Bryan J, Cranston K, Kitzes J, Nederbragt L, Teal TK. 2017. Good enough practices in scientific computing. PLOS Computational Biology 13:e1005510.
Taschuk M, Wilson G. 2017. Ten simple rules for making research software more robust. PLoS Comput Biol 13:e1005412.
More links:
How to name files by Jenny Bryan: http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf
My lab's github org for examples of project names, organization, etc. The exact details have evolved over the years but the general guidelines have stayed pretty consistent. https://github.com/orgs/SchlossLab/repositories
R package example: https://github.com/SchlossLab/mikropml
manuscript examples:
published: https://github.com/SchlossLab/Sovacool_OptiFit_mSphere_2022. This project was a bit complicated so I had to deviate from the exact structure I recommend above.
WIP:  https://github.com/SchlossLab/severe-CDI
