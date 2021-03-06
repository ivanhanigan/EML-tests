
## ----include=FALSE,
## ----cache=FALSE------------------------------------------

#library(knitr)
#library(devtools)
## opts_chunk$set(tidy=FALSE, warning=FALSE, message=FALSE, cache=1,
##                comment=NA, verbose=TRUE, fig.width=6, fig.height=4)
## opts_chunk$set(fig.path = paste("figure/",
##                                 gsub(".Rmd", "", knitr:::knit_concord$get('infile')),
##                                 "-", sep=""),
##                cache.path = paste("cache/",
##                                   gsub(".Rmd", "", knitr:::knit_concord$get('infile') ),
##                                 "/", sep=""))



## ------------------------------------------------------------------------
library(EML)
## library(disentangle)
## require(gdata)
## ## ------------------------------------------------------------------------
## dir()
## metadat <- read.xls("ltern_data_deposit_form_testing.xlsx", sheet= 1, stringsAsFactor=F)
## #"cwt_data_subm_template_2013_testing.xls", sheet= 1)
## str(metadat)
## names(metadat)
## #title <- "Thresholds and Tipping Points in a Sarracenia
## #           Microecosystem at Harvard Forest since 2012"

## title <- metadat[metadat$EML.shortname == 'title', "Definition"]
## #title








f <- eml_read("knb-lter-hfr.205.4")

slotNames(f)
slotNames(f@dataset@distribution@online)
f@dataset@distribution@online


# compared with
morphodir <- "~/.morpho/profiles/ltern2/data/ltern2"
flist <- dir(morphodir)
flist
#for(f in flist){
  f <- flist[6]
  print(f)
  # is it csv?
  try(dat <- read.delim(file.path(morphodir,f)))
  if(
    length(
      grep("xml.version.1.0", names(dat)[1]) == 0
    ) == 0
  ) next
  
  eml <- eml_read(file.path(morphodir,f))
  #slotNames(eml)
  atrb <- eml_get(eml, "attributeList")
str(atrb)
atrb
for(i in 1:length(atrb)){
  print(i)
  print(length(atrb[[i]]))
  print(atrb[[i]][3])
}
atrb[[4]]
  #  eml@dataset@dataTable@.Data[[1]]@attributeList
  cit <- eml_get(eml, "citation_info")
  print(cit)
  #eml@dataset@title
  #slotNames(eml@dataset@dataTable@.Data[[1]])
  #eml_get(eml, "data.set")
  #eml_get( eml, "csv_filepaths")
  eml@dataset@distribution
  eml@dataset@distribution@online
  #   xmlValue(f@additionalMetadata@.Data[[1]]@metadata[[1]][1]$url)

require(XML)
x <- xmlTreeParse(file.path(morphodir,f), useInternal=T)
top <- xmlRoot(x)
str(top)
names(top)
top [[2]] # prints the whole thing
names(top[["dataset"]])
names(top [["dataset"]][["dataTable"]][["physical"]][["distribution"]][["online"]][["url"]])
top [["dataset"]][["dataTable"]][["physical"]][["distribution"]][["online"]][["url"]]

#}

# onwards
f <- eml_read("knb-lter-hfr.205.4")
dat <- eml_get(f, "data.frame")
str(dat)
head(dat)
tail(dat)
# year and day look like full dates.
summary(dat$year)
dat$year <- as.Date(dat$year)
dat$day <- as.Date(dat$day)
dat$hour.min <- as.character(dat$hour.min)
# and valu is number
dat$value.i <- as.numeric(as.character(dat$value.i))
dd <- data_dictionary(dat, show_levels = 10)
dd


## ------------------------------------------------------------------------
col.defs <- c("run.num" = "which run number (=block). Range: 1 - 6. (integer)",
              "year" = "year, 2012",
              "day" = "Julian day. Range: 170 - 209.",
              "hour.min" = "hour and minute of observation. Range 1 - 2400 (integer)",
              "i.flag" =  "is variable Real, Interpolated or Bad (character/factor)",
              "variable" = "what variable being measured in what treatment (character/factor).",
              "value.i" = "value of measured variable for run.num on year/day/hour.min.")

## ------------------------------------------------------------------------
unit.defs = list("which run number",
                 "YYYY",
                 "DDD",
                 "hhmm",
                 c(R = "real", I = "interpolated", B = "bad"),
                 c(control = "no prey added",
                   low = "0.125 mg prey added ml-1 d-1",
                   med.low = "0,25 mg prey added ml-1 d-1",    # ERROR
                   med.high = "0.5 mg prey added ml-1 d-1",
                   high = "1.0 mg prey added ml-1 d-1",
                   air.temp = "air temperature measured just above all plants (1 thermocouple)",
                   water.temp = "water temperature measured within each pitcher",
                   par = "photosynthetic active radiation (PAR) measured just above all plants (1 sensor)"),
                 "number")


## ------------------------------------------------------------------------
dataTable <- eml_dataTable(dat,
                           col.defs = col.defs,
                           unit.defs = unit.defs,
                           description = "Metadata documentation for S1.csv",
                           filename = "S1.csv")


## ------------------------------------------------------------------------
slotNames(dataTable)
slotNames(dataTable@physical)
dataTable@physical@objectName
slotNames(dataTable@physical@distribution)
morpho_dir <- "~/.morpho/profiles//hanigan/data//hanigan"
morpholist<-dir(morpho_dir)
n <- floor(max(na.omit(as.numeric(morpholist))))
n
dataTable@physical@distribution@online@url <- sprintf("ecogrid://knb/hanigan.%s",n+2.1)
dataTable@physical@distribution@online@url
str(dataTable)
eml_config(creator="Carl Boettiger <cboettig@gmail.com>")
eml_write(dataTable, file = "EML_example2.xml", title = "This is an example from the package vignette.")
eml1 <- eml_read("EML_example2.xml")
slotNames(eml1)
slotNames(eml1@dataset@distribution@online)
eml1@dataset@distribution@online
## ------------------------------------------------------------------------
HF_address <- new("address",
                  deliveryPoint = "324 North Main Street",
                  city = "Petersham",
                  administrativeArea = "MA",
                  postalCode = "01366",
                  country = "USA")


## ------------------------------------------------------------------------
publisher <- new("publisher",
    organizationName = "Harvard Forest",
    address = HF_address)


## ------------------------------------------------------------------------
aaron <- as.person("Aaron Ellison <fakeaddress@email.com>")


## ------------------------------------------------------------------------
contact <- as(aaron, "contact")
contact@address = HF_address
contact@organizationName = "Harvard Forest"
contact@phone = "000-000-0000"


## ------------------------------------------------------------------------
# creator <- c(as("Aaron Ellison", "creator"), as("Nicholas Gotelli", "creator"))


## ------------------------------------------------------------------------
## other_researchers <- eml_person("Benjamin Baiser [ctb]",
##                                 "Jennifer Sirota [ctb]")


## ------------------------------------------------------------------------
pubDate <- "2012"


## ----eval=FALSE----------------------------------------------------------
## keys <-
##   c(new("keywordSet",
##       keywordThesaurus = "LTER controlled vocabulary",
##       keyword = c(new("keyword", keyword="bacteria"),
##                   new("keyword", keyword="carnivorous plants"),
##                   ...)
##     ),
##    new("keywordSet",
##       keywordThesaurus = "LTER core area",
##       keyword = ...)


## ------------------------------------------------------------------------
keys <- eml_keyword(list(
 "LTER controlled vocabulary" = c("bacteria",
                                  "carnivorous plants",
                                  "genetics",
                                  "thresholds"),
             "LTER core area" = c("populations",
                                  "inorganic nutrients",
                                  "disturbance"),
                "HFR default" = c("Harvard Forest",
                                  "HFR",
                                  "LTER",
                                  "USA")))


## ------------------------------------------------------------------------
coverage <- eml_coverage(
  scientific_names = "Sarracenia purpurea",
  dates            = c('2012-06-01', '2013-12-31'),
  geographic_description = "Harvard Forest Greenhouse,
                            Tom Swamp Tract (Harvard Forest)",
  NSEWbox          = c( 42.55,  42.42, -72.1, -72.29, 160, 330))


## ------------------------------------------------------------------------
abstract <- "The primary goal of this project is to determine
  experimentally the amount of lead time required to prevent a state
  change. To achieve this goal, we will (1) experimentally induce state
  changes in a natural aquatic ecosystem - the Sarracenia microecosystem;
  (2) use proteomic analysis to identify potential indicators of states
  and state changes; and (3) test whether we can forestall state changes
  by experimentally intervening in the system. This work uses state-of-the
  art molecular tools to identify early warning indicators in the field
  of aerobic to anaerobic state changes driven by nutrient enrichment
  in an aquatic ecosystem. The study tests two general hypotheses: (1)
  proteomic biomarkers can function as reliable indicators of impending
  state changes and may give early warning before increasing variances
  and statistical flickering of monitored variables; and (2) well-timed
  intervention based on proteomic biomarkers can avert future state changes
  in ecological systems."


## ------------------------------------------------------------------------
rights <- "This dataset is released to the public and may be freely
  downloaded. Please keep the designated Contact person informed of any
  plans to use the dataset. Consultation or collaboration with the original
  investigators is strongly encouraged. Publications and data products
  that make use of the dataset must include proper acknowledgement. For
  more information on LTER Network data access and use policies, please
  see: http://www.lternet.edu/data/netpolicy.html."


## ------------------------------------------------------------------------
library(RWordXML)
library(XML)
f2 <- wordDoc(system.file("examples", "methods.docx", package="EML"))
doc <- f2[[getDocument(f2)]]
txt <- xpathSApply(doc, "//w:t", xmlValue)
## FIXME add <title> <section> and <para> blocking back:
method <- paste(txt, collapse = "\n\n")


## ------------------------------------------------------------------------
methods <- new("methods", methodStep = c(new("methodStep", description = method)))


## ------------------------------------------------------------------------
hf205 <- eml_read(system.file("examples", "hf205.xml", package="EML"))
additionalMetadata <- hf205@additionalMetadata # extracted from previous eml file


## ------------------------------------------------------------------------
dataset <- new("dataset",
                title = title,
                creator = creator,
                contact = contact,
                pubDate = pubDate,
                intellectualRights = rights,
                abstract = abstract,
                associatedParty = other_researchers,
                keywordSet = keys,
                coverage = coverage,
                methods = methods,
                dataTable = c(dataTable))



## ------------------------------------------------------------------------
eml <- new("eml",
            packageId = uuid::UUIDgenerate(),
            system = "uuid", # type of identifier
            dataset = dataset,
            additionalMetadata = additionalMetadata)


## ------------------------------------------------------------------------
# is this broken?
# eml     <- eml( dataset = dat,
#                 title = title,
#                 creator = creator,
#                 contact = contact,
#                 pubDate = pubDate,
#                 associatedParty = other_researchers,
#                 intellectualRights = rights,
#                 abstract = abstract,
#                 keywordSet = keys,
#                 coverage = coverage,
#                 methods = method,
#                 additionalMetadata = additionalMetadata
#               )


## ------------------------------------------------------------------------
eml_write(eml, file="hf205_from_EML.xml")


## ------------------------------------------------------------------------
eml_validate("hf205_from_EML.xml")
