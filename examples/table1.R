#Example of using table 1

library(tidyverse)
library(here)
library(table1)
library(readr)


df<-read_delim("your_data.tsv",delim="\t")

#possible baseline variables from HUNT4 with NT4 in the name
df %>% select(contains("NT4")) %>% names() %>% sort()

#do some cleaning up of the variables I want to use
df<-df %>% mutate(Se.CRP.NT4BLM=parse_number(Se.CRP.NT4BLM)) %>% 
  mutate(DiaEv.NT4BLQ1=as.factor(DiaEv.NT4BLQ1)) %>% #make a factor
  mutate(DiaEv.NT4BLQ1=fct_recode(DiaEv.NT4BLQ1,"Yes"="Ja","No"="Nei")) #change to English
  
#set labels
label(df$Bmi.NT4BLM) <- "BMI"
label(df$DiaEv.NT4BLQ1) <- "Ever Diagnosed with Diabetes"
label(df$SeCrea.NT4BLM) <- "Serum Creatine (mmol/L)"
label(df$Se.CRP.NT4BLM) <- "Serum high sensitivity C-reactive protein (mg/L)"
label(df$SeHDLChol.NT4BLM) <- "Serum HDL cholesterol (mmol/L)"
label(df$SeTrig.NT4BLM) <- "Serum Trigyclerides (mmol/L)" 
label(df$BloHbA1cIFCC.NT4BLM) <- "HbA1c (mmol/mol)"

#make a custom render function for prevalence (not sure what it is doing for NA in the denominator here)
rndr <- function(x, ...) {
  y <- render.default(x, ...)
  if (is.logical(x)) y[2] else y
}

#making logical class variables for use of a logical render function to show prevalence nicer
df<-df%>%mutate(DiaEv_log=DiaEv.NT4BLQ1=="Yes")
label(df$DiaEv_log) <- "Ever Diagnosed with Diabetes n(%)"

#create data frame with median and mean
table1(~ Bmi.NT4BLM + DiaEv_log + SeTrig.NT4BLM + SeCrea.NT4BLM + Se.CRP.NT4BLM + SeHDLChol.NT4BLM, 
       data = df,
       render=rndr,
       render.categorical = "FREQ (PCTnoNA%)", #what percentage to not include NA in denominator
       render.continuous=c("Mean (SD)", "Median [Q1 &ndash; Q3]"))
