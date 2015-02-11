glb <- new('Global', 'biomon')
bio <- new('Action')

shinyServer(
  function(input, output, session) {    
    #--- Local data definition
    analysisFolder <- Global.getAnalysis(glb)
    matricesFolder <- Global.getMatrices(glb)
    
    anlzFilNames <- c('Choose ...', list.files(analysisFolder))
    mtrsFilNames <- c('Choose ...', list.files(matricesFolder))
    
    #--- DROP-DOWN Analysis
    output$sInputAnalysis <- renderUI({
      if(length(input$sInputAnalysis) == 0 ){
        selectInput('inpAnalysis', 'Analysis', as.list(anlzFilNames))
      }
    })
    #--- DROP-DOWN Matrices
    output$sInputAttributes <- renderUI({
        selectInput('inpAttributes', 'Attributes', as.list(mtrsFilNames))
    })
    output$sInputSpecies <- renderUI({
      selectInput('inpSpecies', 'Species', as.list(mtrsFilNames))
    })
    output$sInputFactor <- renderUI({
      selectInput('inpFactor', 'Factors', as.list(mtrsFilNames))
    })
    output$sInputEnvironment <- renderUI({
      selectInput('inpEnvironment', 'Environment', as.list(mtrsFilNames))
    })
    output$sInputSpace <- renderUI({
      selectInput('inpSpace', 'Space', as.list(mtrsFilNames))
    })
    #--- PUSHBUTTON Execute
    output$execMsg <- renderPrint({
      # Take a dependency on input$goButton
      if (input$btnExecute > 0 ){
        vAnalysisFile <- paste0(gbl.analysis, input$inpAnalysis)
        Action.btnExecute(bio, vAnalysisFile)
      }
    })
    #--- FOLDER paths    
    output$matricesPath <- renderText({ 
      paste( matricesFolder )
    })
    output$analysisPath <- renderText({ 
      paste( analysisFolder )
    })
# --- GLOBAL values
    observe(gbl.mAttributes  <<- paste0(gbl.matrices, input$inpAttributes))
    observe(gbl.mEnvironment <<- paste0(gbl.matrices, input$inpEnvironment))
    observe(gbl.mFactor      <<- paste0(gbl.matrices, input$inpFactor))
    observe(gbl.mSpace       <<- paste0(gbl.matrices, input$inpSpece))
    observe(gbl.mSpecies     <<- paste0(gbl.matrices, input$inpSpecies))

    observe(gbl.mAnalysis    <<- paste0(gbl.analysis, input$inpAnalysis))

# --- UPLOAD analysis
  output$analysisUploaded <- renderText({
    inFile1 <- input$file1
  
  if (is.null(inFile1)){
    return(NULL)
  }else{
    file.copy(inFile1$datapath, paste0(analysisFolder,inFile1$name), overwrite=TRUE, copy.mode=TRUE)  
    return("[Refresh the page]")
  }
  })

# --- UPLOAD matrices
  output$matrixUploaded <- renderText({
    inFile2 <- input$file2
    
    if (is.null(inFile2)){
      return(NULL)
    }else{
      file.copy(inFile2$datapath, paste0(matricesFolder,inFile2$name), overwrite=TRUE, copy.mode=TRUE)  
      return("[Refresh the page]")
    }
  })
  } #Function
)