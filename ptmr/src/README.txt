potential field motion planning

El algoritmo de planificación de campo potencial está dentro de la carperta 'model'

Hay dos modelos:
                 Modelo simple. planificación sencilla con dos obstáculos primitivos

                 Modelo Campus Leganés UC3M. Planificación a través del campus de leganés


El segundo modelo (Campus Leganés) está en función de las funciones que se encuentra en la carpeta 'lib'. La función de generar el campo potencial de los obstáculos 'obstacleUC3MField', en este caso los edificios del campus de leganés, que es dependiente de la función 'generationPoint' para generar los puntos de los obstáculos. Y la función de realizar la planificación por campos potenciales 'potentialFieldPathPlanning'.