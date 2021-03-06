
library(shiny)
library(rmarkdown)
library(lubridate)
library(dplyr)


shinyUI(
  navbarPage("WFMU Playlist Explorer ALPHA VERSION",
             # --------- Station/ ----------------------------------
             tabPanel("Station",
                      titlePanel("Top Artists and Songs Played on WFMU"),
                      
                      sidebarLayout(
                        # Sidebar with a slider and selection inputs
                        sidebarPanel(
                          selectInput("selection", "Are the DJs On Current Schedule?:",
                                      choices = c('ALL','YES','NO')),
                          h4('Be aware a wide date range could take many seconds to process.'),
                          sliderInput("years_range",
                                      "Year Range:",
                                      min = min_year,
                                      max = year(Sys.Date()),
                                      sep = "",
                                      value = c(year(Sys.Date())-3,year(Sys.Date()))),
                          actionButton("update","Update")
                        ),
                        
                        # Show Word Cloud
                        mainPanel(
                          fluidRow(
                            h4('Top Artists'),
                            tabsetPanel(type = "tabs",
                                        tabPanel("Word Cloud", plotOutput("cloud")),
                                        tabPanel("Table", tableOutput("table_artists"))
                            )),
                          fluidRow(
                            h4('Top Songs'),
                            tableOutput("table_songs")
                          )
                        )
                      )
             ),
             # --------- DJs/ ------------------------------------
             navbarMenu("DJs",
                        # --------- DJs/DJ Profile -----------------------------
                        tabPanel("DJ Profile",
                                 titlePanel("DJ Profile"),
                                 sidebarLayout(
                                   sidebarPanel(
                                     selectInput("show_selection", "Show Name:",
                                                 choices = DJKey$ShowName,
                                                 selected = 'Teenage Wasteland'),
                                     hr(),
                                     uiOutput("DJ_date_slider") 
                                     #, actionButton("DJ_update","Update")
                                   ),
                                   
                                   # Show Word Cloud
                                   mainPanel(
                                     fluidRow(
                                       h4('Top Artists'),
                                       tabsetPanel(type = "tabs",
                                                   tabPanel("Word Cloud", plotOutput("DJ_cloud")),
                                                   tabPanel("Table", tableOutput("DJ_table_artists"))
                                       )),
                                     fluidRow(
                                       h4('Top Songs'),
                                       tableOutput("DJ_table_songs")
                                     )
                                   )
                                 )
                        ),
                        # --------- DJs/Find Simlar DJs -------------------
                        tabPanel("Find Similar DJs",
                                 titlePanel("Find Similar DJs"),
                                 sidebarLayout(
                                   # Sidebar with a slider and selection inputs
                                   sidebarPanel(
                                     selectInput("show_selection_2", "Show Name:",
                                                 choices = DJKey$ShowName,
                                                 selected = 'Teenage Wasteland')
                                   ),
                                   
                                   # Show Word Cloud
                                   mainPanel(
                                     fluidRow(
                                       h4('Most Similar Shows Based on Common Artists'),
                                       tableOutput("DJ_table_similar")
                                       
                                     ),
                                     fluidRow(
                                       h4('DJ Neighborhood') 
                                       , plotOutput("DJ_chord")
                                     )
                                   )
                                 )
                        ),
                        # --------- DJs/Compare Two DJs -----------------------
                        tabPanel("Compare Two DJs",
                                 titlePanel("Compare Two DJs"),
                                 fluidRow(
                                   column(4,
                                          selectInput("show_selection_3", "Show Name:",
                                                      choices = DJKey$ShowName,
                                                      selected = 'Teenage Wasteland')
                                   ),
                                   column(4,
                                          selectInput("show_selection_4", "Show Name:",
                                                      choices = DJKey$ShowName,
                                                      selected = 'Bob Brainen')
                                   )
                                 ),
                                 fluidRow(
                                   column(6,
                                          h4('Similarity Index'),
                                          h5('Black curve is frequency of all DJ pair similarities. Vertical blue line is similarity of this pair.'),
                                          h5(' The bulge at the low end shows WFMU DJs are not very similar to each other, in general.')
                                   ),
                                   column(6,
                                          plotOutput("DJ_plot_sim_index",height="100px")
                                   )
                                 ),
                                 fluidRow(column(11,offset=1,h4("Play Counts of Common Artists and Songs"))),
                                 fluidRow(
                                   column(5,
                                          h4('Artists in Common'),
                                          tableOutput("DJ_table_common_artists")
                                   ),
                                   column(7,
                                          h4('Songs in Common'),
                                          tableOutput("DJ_table_common_songs")
                                   )
                                 )
                        )
             ),
             # --------- Artists/ ----------------------------------
             tabPanel("Artists",
                      titlePanel("Artists Plays by DJ Over Time"),
                      sidebarLayout(
                        # Sidebar with a slider and selection inputs
                        sidebarPanel(
                          h4('1) Type a few letters of the artist name then click "Find Artists."'),
                          h5('     Type no more than one word in the artist name.'),
                          h5('     Check the word cloud on the first page for abbreviations in use. "Stones" will find The Rolling Stones'),
                          textInput("artist_letters", label = h4("Give me a clue!"), value = "Abba"),
                          actionButton("artist_update_1","Find Artists"),
                          h4('2) Now choose the specific artist. Beware of misspellings!'),
                          uiOutput('SelectArtist'),
                          h4('3) Change the date range?'),
                          sliderInput("artist_years_range",
                                      "Year Range:",
                                      min = min_year,
                                      max = year(Sys.Date()),
                                      sep = "",
                                      value = c(2002,year(Sys.Date()))),
                          fluidRow(
                            h4('4) Change threshold to show DJ?'),
                            selectInput("artist_all_other",
                                        "Threshold of Minimum Plays to show DJ",
                                        selected = 3,
                                        choices=1:9)
                          )
                        ),
                        
                        mainPanel(
                          fluidRow(
                            h4('Artist Plays per Quarter'),
                            plotOutput("artist_history_plot"),
                            h4('Songs Played by Artist'),
                            tableOutput('top_songs_for_artist')
                          )
                        )
                      )
             ),
             # --------- Songs/ ----------------------------------
             # tabPanel("Songs",
             #          titlePanel("Nothing Here Yet")
             # ),
             # --------- About/ ----------------------------------
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("about.md")
                      )
             )
             
  )
)
