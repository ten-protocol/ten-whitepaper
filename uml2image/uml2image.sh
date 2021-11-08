#!/bin/bash
java -jar plantuml.jar "../interaction-uml/**.plantuml" -o "../images"
java -jar plantuml.jar "../class-uml/**.plantuml" -o "../images"