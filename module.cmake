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
  vtkRenderingLabel
  vtkRenderingLOD
  vtkRenderingVolume${VTK_RENDERING_BACKEND}
  vtkTestingGenericBridge
  vtkTestingRendering
  vtkViewsContext2D
  )

if(Module_vtkGUISupportQtOpenGL AND ${VTK_VERSION} VERSION_LESS "8.1")
  list(APPEND
    vtkGUISupportQtOpenGL
    vtkRenderingQt
    vtkViewsQt
    )
endif()

vtk_module( WikiExamples
  DEPENDS
    ${DEPENDS}
  DESCRIPTION
    "${DOCUMENTATION}"
)
