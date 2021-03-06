
library(drake)
library(mlr)
library(kernlab)
library(dplyr)
library(visNetwork)

my_plan <- drake_plan(
  dat = read.csv(
    "https://raw.githubusercontent.com/mini-pw/2020Z-ProgramowanieWR/master/Wyjsciowki/W2/gr1/SawickiJan/ShinyIris/iris.csv"
  ),
  biniarized_dat = dat %>% mutate(variety = ifelse(variety == "Setosa", "1", "0")),
  task = makeClassifTask(id = "drake_test", data = biniarized_dat, target = "variety"),
  bench = benchmark(
    learners = list(
      makeLearner("classif.randomForest"),
      makeLearner("classif.ksvm"),
      makeLearner("classif.nnet")
    ),
    tasks = task
  ),
  graph = plotBMRBoxplots(bench),
  save = write.csv(biniarized_dat, file = "binarized_iris.csv")
)

config = make(my_plan)

vis_drake_graph(drake_config(my_plan))
