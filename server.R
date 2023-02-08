##########################
# About & Team Dashboard              
# by Yue Lyu and Kehe Zhang                 
# server.R file   

# Define server logic required to draw a histogram
server <- function(input, output) {
    # 
    output$Map <- renderLeaflet({
        l <- leaflet(shp) %>% addTiles()
        pal <- colorNumeric(palette = "YlOrRd", domain = shp$npop20_2019)
        # add text
        labels <- sprintf("<strong> ZCTA: %s </strong> <br/> <strong> -Year 2010- </strong> <br/> Total population: %s <br/> Population 20+: %s <br/> Death rate: %s <br/> <strong> -Year 2015- </strong> <br/> Total population: %s <br/> Population 20+: %s <br/> Death rate: %s <br/> <strong> -Year 2019- </strong> <br/> Total population: %s <br/> Population 20+: %s <br/> Death rate: %s", 
                          shp$GEOID10, shp$npop_2010, shp$npop20_2010, shp$rate_q_2010, shp$npop_2015, shp$npop20_2015,shp$rate_q_2015, shp$npop_2019, shp$npop20_2019, shp$rate_q_2019) %>%
            lapply(htmltools::HTML)
        library(leaflet.extras)
        interactive<-  l %>%
            addPolygons(
                layerId = ~shp$GEOID10,
                group="marker",
                color = "grey", weight = 1,
                fillColor = ~ pal(shp$npop20_2019), fillOpacity = 0.5,
                highlightOptions = highlightOptions(weight = 4),
                label = labels,
                labelOptions = labelOptions(
                    style = list(
                        "font-weight" = "normal",
                        padding = "3px 8px"
                    ),
                    textsize = "15px", direction = "auto"
                )
            ) %>%
            addLegend(
                pal = pal, values = ~shp$npop20_2019, opacity = 0.5,
                title = "Population (20+) in 2019", position = "bottomright"
            ) %>%
            #addMarkers(~long, ~lat, popup = ~GEOID10, group="marker2") %>%
            addSearchFeatures(
                targetGroups  = "marker",
                options = searchFeaturesOptions(zoom = 13, openPopup = TRUE, firstTipSubmit = TRUE,
                                                autoCollapse = TRUE, hideMarkerOnCollapse = F, position = "topleft" ))
        
        interactive
    })
    
    
    output$Plot1 <- renderPlot({
        ggplot(yearly, aes(x=year, y=mean_rate)) + geom_point() + geom_line()+
            labs(x="Year", y="Opioid OD Mortality Rate")+
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  panel.background = element_blank(), axis.line = element_line(colour = "black"),
                  axis.text.x = element_text(angle=45))+
            ggtitle("Average fatal opioid overdose rate (per 100k)\nin Massachusetts")+
            scale_x_continuous(breaks = seq(2005, 2020, by = 1))
    })
    
    
    
    observeEvent(input$Map_shape_click, {
        click <- input$Map_shape_click
        dat.pred$rate_q <- factor(dat.pred$rate_q, levels=c("Q1", "Q2", "Q3", "Q4", "Q5"))
        yearly1 <-  dat.pred %>% filter(zipcode %in% click$id) #%>% mutate(label=paste0("Zip code ", click$id))
        # yearly$label <- "County average"
        # yearly <- yearly %>% rename(rate=mean_rate)
        # plot_dt <- rbind(yearly1[,c("year", "rate_q", "label")], yearly)
        output$Plot2 <- renderPlot({
            ggplot(data=yearly1, aes(x=year, y=rate_q)) + geom_point() + geom_path(data=yearly1, aes(x=year, y=rate_q), group=1)+
                #scale_color_manual(values=c( "black","red"))+
                labs(x="Year", y="Opioid OD Mortality Rate in Quintiles")+
                theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                      panel.background = element_blank(), axis.line = element_line(colour = "black"),
                      axis.text.x = element_text(angle=45))+
                ggtitle(paste0("Fatal opioid overdose rate (in quintiles)\nin Zip Code ",click$id))+
                scale_x_continuous(breaks = seq(2005, 2020, by = 1))+
                scale_y_discrete(limits=c("Q1", "Q2", "Q3", "Q4", "Q5"))
        })
        
    })
}
