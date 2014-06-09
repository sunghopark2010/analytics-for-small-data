DetermineVariableType <- function(df, col.name, numeric.factor.variables=vector()) {
  if (col.name %in% numeric.factor.variables) {
    return('factor')
  }
  r.var.type <- class(df[[col.name]])
  if (r.var.type == 'integer') {
    return('numeric')
  }
  return(r.var.type)
}

HandleFactorFactor <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default factor variable analyses
  AnalyzeFactor()
  # Run 
  return(TRUE)
}

HandleFactorNumeric <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default factor variable analyses
  AnalyzeFactor()
  return(TRUE)
}

HandleNumericFactor <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default numeric variable analyses
  AnalyzeNumeric()
  return(TRUE)
}

HandleNumericNumeric <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default numeric variable analyses
  AnalyzeNumeric()
  return(TRUE)
}

AnalyzeFactor <- function(x, y, t=vector(), x.name, y.name, t.name="", output.dir) {
  
}

AnalyzeNumeric <- function(x, y, t=vector(), x.name, y.name, t.name="", output.dir) {
  
}