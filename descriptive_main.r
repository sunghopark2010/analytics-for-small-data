#!/usr/bin/env Rscript

# Source utility functions
source("descriptive_utils.r")

# Get names of project, data file path, dependent variable and time variable, numeric factor variables
#args <- commandArgs(trailingOnly = TRUE)
#project.name <- args[1]
#source.data.path <- args[2]
#dep.var.name <- args[3]
#time.var.name <- args[4]
#numeric.factor.variables <- unlist(strsplit(args[5], split=","))

project.name <- 'example_project'
source.data.path <- 'example_data.csv'
dep.var.name <- 'fraud_flg'
time.var.name <- 'id'
numeric.factor.variables <- c("fraud_flg")

# Load the data
source.data <- read.csv(source.data.path)
str(source.data)

# Create a folder to save the outputs
dir.create(project.name)

# Get the type of dependent variable
dep.var.type <- DetermineVariableType(source.data, dep.var.name, numeric.factor.variables)

# Start handling each variable
sapply(colnames(source.data), function(ind.var.name) {
  # Create a directory for this variable
  dir.create(paste(project.name, "/", ind.var.name,sep=""))
  if (ind.var.name == dep.var.name) {
    
  } else {
    ind.var.type <- DetermineVariableType(source.data, ind.var.name, numeric.factor.variables)
    # Strategy pattern
    if (ind.var.type == 'factor' && dep.var.type == 'factor') {
      HandleFactorFactor(source.data[[ind.var.name]], source.data[[dep.var.name]], source.data[[time.var.name]], ind.var.name, dep.var.name, time.var.name, project.name)
    } else if (ind.var.type == 'factor' && dep.var.type == 'numeric') {
      HandleFactorNumeric(source.data[[ind.var.name]], source.data[[dep.var.name]], source.data[[time.var.name]], ind.var.name, dep.var.name, time.var.name, project.name)
    } else if (ind.var.type == 'numeric' && dep.var.type == 'factor') {
      HandleNumericFactor(source.data[[ind.var.name]], source.data[[dep.var.name]], source.data[[time.var.name]], ind.var.name, dep.var.name, time.var.name, project.name)
    } else if (ind.var.type == 'numeric' && dep.var.type == 'numeric') {
      HandleNumericNumeric(source.data[[ind.var.name]], source.data[[dep.var.name]], source.data[[time.var.name]], ind.var.name, dep.var.name, time.var.name, project.name)
    } else {
      write(paste("Warning: could not decide whether ", ind.var.name, " is a numeric or factor; skipping this variable."), stderr())
    }
  }
})

