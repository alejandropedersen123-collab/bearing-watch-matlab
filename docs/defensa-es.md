# Cómo defender este proyecto en una entrevista

## Explicación de un minuto

«El proyecto convierte registros de vibración en avisos de anomalía explicables. Aprende exclusivamente con rodamientos sanos, fija el umbral con otro archivo y evalúa con una carga de motor que no se utilizó al entrenar. Además de las métricas, comprueba errores de sensor, persistencia de alarmas y cambios de ganancia. Es un prototipo de monitorización, no una predicción de vida útil».

## Demostración de cinco minutos

1. Abre `results/benchmark.png` y explica qué representa cada punto y cada ventana.
2. Enseña la tabla de separación de archivos del README.
3. Abre `read_record.m`: el archivo 99 contiene también datos del 98. Explica por qué seleccionar el canal exacto evita contaminar la calibración.
4. Ejecuta las pruebas y enseña `gain_stress.csv`. Explica un caso en el que el sistema falla.
5. Explica que los datos son de un banco de laboratorio con defectos inducidos y que necesitas validar sensores y máquinas reales.

## Preguntas que debes poder responder

- ¿Qué cambia al multiplicar la aceleración por dos? RMS cambia; curtosis y factor de cresta no.
- ¿Qué es la curtosis de Pearson? Momento central cuarto dividido por la varianza al cuadrado; una gaussiana tiene valor 3.
- ¿Por qué no dividir ventanas aleatoriamente? Ventanas del mismo registro comparten máquina, adquisición y condiciones.
- ¿Por qué persistencia? Reduce avisos por puntos aislados, a costa de retrasar la alarma.
- ¿Qué significa un score de 10? Distancia en el espacio de características normalizadas, no probabilidad de fallo.
- ¿Por qué no anuncias un 100 % de fiabilidad? Los resultados proceden de cuatro archivos y un único banco de ensayos.

## Para hacerlo tuyo

Reproduce el resultado sin ayuda; cambia la persistencia y añade una prueba; incorpora un nuevo grupo de archivos con un protocolo decidido antes de mirar sus etiquetas. Documenta qué decisiones tomaste tú. Describe con honestidad la ayuda de IA recibida y no atribuyas experiencia de campo que todavía no has tenido.
