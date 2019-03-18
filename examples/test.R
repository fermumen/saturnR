library(leafletfmm)
library(sf)
library(saturnR)

ufs.l <- list.files("./data-raw/3tp_ufs/", full.names = T)
ufs.l <- lapply(ufs.l, read_ufs, load_geometry = TRUE)
names(ufs.l) <- c("AM","IP","PM")

ufs.l <-  lapply(ufs.l, st_transform,"+init=epsg:4326")


offsetable_links <- function(network){
  paste(network$nodeA, network$nodeB) %in% paste(network$nodeB, network$nodeA) %>% as.numeric()
}

ufs.l <- lapply(ufs.l, function(x) x %>% mutate(offsetable = offsetable_links(x)))

pal <- colorNumeric("magma",domain = 0:111)

scale_w = 750

m <- leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
  addProviderTiles(provider = providers$CartoDB.Positron)
i <- 0
for (TP in ufs.l) {
  i <- i + 1
  m <- m %>%
    addPolylines(data = TP,
                 weight = ~(actual_flow/scale_w)+1, offset = ~(4.5 + (actual_flow/(scale_w*2))) * offsetable,
                 color=~pal(cruise_speed), opacity =0.8,
                 label = ~paste("veh:",round(actual_flow,0),", speed: ",round(cruise_speed,0)),
                 group = names(ufs.l)[i])
}


m %>% addPolylines(data = ufs.l$AM, weight = 0.5, color= "black",opacity = 1) %>%
  addLegend(data = ufs.l$AM, pal = pal, values = ~cruise_speed) %>%
  addLayersControl(baseGroups = names(ufs.l),options = layersControlOptions(collapsed = FALSE))
