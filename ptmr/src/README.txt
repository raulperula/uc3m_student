potential field motion planning

El algoritmo de planificaci�n de campo potencial est� dentro de la carperta 'model'

Hay dos modelos:
                 Modelo simple. planificaci�n sencilla con dos obst�culos primitivos

                 Modelo Campus Legan�s UC3M. Planificaci�n a trav�s del campus de legan�s


El segundo modelo (Campus Legan�s) est� en funci�n de las funciones que se encuentra en la carpeta 'lib'. La funci�n de generar el campo potencial de los obst�culos 'obstacleUC3MField', en este caso los edificios del campus de legan�s, que es dependiente de la funci�n 'generationPoint' para generar los puntos de los obst�culos. Y la funci�n de realizar la planificaci�n por campos potenciales 'potentialFieldPathPlanning'.