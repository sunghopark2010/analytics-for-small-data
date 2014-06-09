library(pastecs)
library(Hmisc)

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
  AnalyzeFactor(x, paste(output.dir, "/", x.name, sep=""), x.name)
  return(TRUE)
}

HandleFactorNumeric <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default factor variable analyses
  AnalyzeFactor(x, paste(output.dir, "/", x.name, sep=""), x.name)
  return(TRUE)
}

HandleNumericFactor <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default numeric variable analyses
  AnalyzeNumeric(x, paste(output.dir, "/", x.name, sep=""), x.name)
  return(TRUE)
}

HandleNumericNumeric <- function(x, y, t, x.name, y.name, t.name, output.dir) {
  # Run default numeric variable analyses
  AnalyzeNumeric(x, paste(output.dir, "/", x.name, sep=""), x.name)
  return(TRUE)
}

AnalyzeNumeric <- function(x, output.dir, analysis.name) {
  output.file.default.path = paste(output.dir, "/", analysis.name, sep="")
  # Get basic descriptive statistics
  sink(paste(output.file.default.path, "_describe.txt", sep=""))
  d<-describe(x)
  print(d)
  sink()
  write.table(stat.desc(x), paste(output.file.default.path, "_stat_desc.txt", sep=""), sep=",", quote=FALSE)
  
  # Define a chart title
  chart.title <- paste(analysis.name, " (N=", d$counts["n"], " ,n=", strtoi(d$counts["n"]) - strtoi(d$counts["missing"]), ")",sep="")
  
  # Draw a box plot
  png(paste(output.file.default.path, "_box_plot.png", sep=""))
  b <- boxplot(x, main=chart.title, xlab=analysis.name, ylab="value")
  dev.off()
  sink(paste(output.file.default.path, "_box_plot.txt", sep=""))
  print("stats");print(b$stats)
  print("n");print(b$n)
  print("conf");print(b$conf)
  sink()
  
  # Draw histogram
  png(paste(output.file.default.path, "_histogram.png", sep=""))
  h <- hist(x, main=chart.title, xlab=analysis.name, freq=FALSE)
  dev.off()
  sink(paste(output.file.default.path, "_histogram.txt", sep=""))
  print("breaks");print(h$breaks)
  print("counts");print(h$counts)
  print("density");print(h$density)
  print("mids");print(h$mids)
  sink()
}

AnalyzeFactor <- function(x, output.dir, analysis.name) {
  # Get frequencies of unique values
  frequency.table <- table(x)
  frequency.table <- frequency.table[order(frequency.table, decreasing=TRUE)]
  frequency.df <- data.frame(names(frequency.table), as.vector(frequency.table))
  colnames(frequency.df) <- c("value", "abs.freq")
  frequency.df$rel.freq <- as.vector(prop.table(frequency.df$abs.freq))
  
  # Write to a file
  write.table(frequency.df, paste(output.dir, "/", analysis.name, "_frequency_table.txt", sep=""), sep=",", quote=FALSE, row.names=FALSE, col.names=FALSE)
  
  # Define a chart title
  chart.title <- paste(analysis.name, " (n=", sum(frequency.df$abs.freq), ")",sep="")
  
  # Draw a pie chart and save it
  png(paste(output.dir, "/", analysis.name, "_pie_chart.png", sep=""))
  pie(frequency.df$rel.freq, paste(frequency.df$value, " (n=", frequency.df$abs.freq, ", %=", round(frequency.df$rel.freq, digits=4)*100, ")", sep=""), main=chart.title)
  dev.off()
  
  # Draw a bar chart and save it
  png(paste(output.dir, "/", analysis.name, "_bar_chart.png", sep=""))
  barplot(frequency.df$rel.freq, main=chart.title, names.arg=frequency.df$value)
  dev.off()
}