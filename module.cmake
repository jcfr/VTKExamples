set(DOCUMENTATION "A collection of examples illustrating how to use VTK")

set(DEPENDS
  vtkChartsCore
  vtkCommonColor
  vtkCommonComputationalGeometry
  vtkCommonSystem
  vtkFiltersExtraction
  vtkFiltersFlowPaths
  vtkFiltersGeneric
  vtkFiltersGeometry
  vtkFiltersHybrid
  vtkFiltersModeling
  vtkFiltersPoints
  vtkFiltersProgrammable
  vtkFiltersTexture
  vtkFiltersVerdict
  vtkGeovisCore
  vtkIOExodus
  vtkIOExport
  vtkIOImport
  vtkIOInfovis
  vtkIOPLY
  vtkIOParallel
  vtkIOParallelXML
  vtkImagingColor
  vtkImagingFourier
  vtkImagingHybrid
  vtkImagingMath
  vtkImagingMorphological
  vtkImagingSources
  vtkImagingStatistics
  vtkImagingStencil
  vtkInfovisLayout
  vtkInteractionImage
  vtkRenderingAnnotation
  vtkRenderingContext${VTK_RENDERING_BACKEND}
  vtkRenderingImage
  vtkRenderingLOD
  vtkRenderingVolume${VTK_RENDERING_BACKEND}
  vtkTestingGenericBridge
  vtkTestingRendering
  vtkViewsContext2D
  )

# Optional dependencies
foreach(vtk-module IN ITEMS
  vtkInfovisBoostGraphAlgorithms
  vtkInfovisViews
  vtkIOFFMPEG
  vtkIOMySQL
  vtkFiltersParallelStatistics
  vtkGUISupportQtOpenGL
  vtkRenderingQt
  vtkViewsQt
  )
  if(TARGET ${vtk-module})
    list(APPEND
      ${vtk-module}
      )
  endif()
endforeach()

vtk_module( WikiExamples
  DEPENDS
    ${DEPENDS}
  DESCRIPTION
    "${DOCUMENTATION}"
)
