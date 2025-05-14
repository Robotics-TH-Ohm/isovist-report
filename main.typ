#let title = "TODO"

#set document(
  title: title,
  author: {
    "Tan Phat Nguyen"
    "Nils Weber"
  },
)

#set text(font: "New Computer Modern Sans", lang: "de", size: 12pt)

#set page(
  paper: "a4",
  margin: (right: 2.5cm, left: 2.5cm, top: 2.5cm, bottom: 2cm),
)

#show (heading): it => [
  #it
  #v(0.75em)
]

#set page(numbering: "1")
#counter(page).update(1)
#set heading(numbering: "1.")

#set align(center)

#strong(text(title, size: 1.5em), delta: 700)
#v(0.5em)
#text("Vorname Name")\
#strong(text("Tan Phat Nguyen"))\
#strong(text("Nils Weber"))
#v(1em)

#set align(top + left)

#set par(justify: true)

= Einleitung

Die Fähigkeit mobiler Roboter zur autonomen Bewegung in ihrer Umgebung erfordert die exakte Kenntnis des eigenen Standorts. Diese Selbstlokalisierung ist die Grundlage für sinnvolle Interaktionen mit der Umgebung. Ein Roboter benötigt eine präzise Positionsbestimmung auf einer Karte, da die Erledigung von Aufgaben andernfalls erheblich erschwert oder unmöglich ist. Anwendungen wie autonome Reinigung, Güterzustellung oder Führungsaufgaben setzen eine kontinuierliche und genaue Selbstverortung voraus. Während die Lokalisierung im Außenbereich durch globale Navigationssatellitensysteme (GNSS) wie GPS weitgehend etabliert ist, bleibt sie in Innenräumen eine signifikante Herausforderung.

Mit der fortschreitenden Entwicklung von Lokalisierungsalgorithmen werden zunehmend komplexere Szenarien in der Forschung betrachtet. Ein Beispiel hierfür ist das sogenannte "Kidnapped Robot Problem" (KRP). Dieses Szenario beschreibt eine Situation, in der der Roboter an einen ihm unbekannten Ort innerhalb seiner Arbeitsumgebung gebracht wird oder seine aktuelle Position verliert. Die erfolgreiche Bewältigung des KRP gilt als Indikator für die Fähigkeit eines Roboters, sich nach einem Lokalisierungsfehler zu reorientieren und seine Aufgaben fortzusetzen. Dieses Problem zeigt die Anforderung an Lokalisierungsansätze, die auch in untypischen Situationen zuverlässig arbeiten.

In der vorliegenden Arbeit wird ein Ansatz zur Indoor-Lokalisierung untersucht, der auf die Bewältigung des Kidnapped Robot Problems ausgerichtet ist. Der Fokus liegt auf der Nutzung von Isovisten in Verbindung mit LiDAR-Sensorik. Isovisten beschreiben den von einem bestimmten Punkt aus sichtbaren Raum. Sie erfassen die Form und Struktur der unmittelbaren Umgebung, indem sie die direkt vom Beobachter einsehbaren Punkte definieren. Die Struktur des sichtbaren Raumes kann als charakteristisch für einen Standort betrachtet werden, was potenziell zur Wiedererkennung nach einer Positionsveränderung des Roboters genutzt werden kann. Ein LiDAR-Sensor ermöglicht die Erfassung der für die Isovisten-Analyse erforderlichen Umgebungsgeometrie.

Die zentrale Forschungsfrage dieser Arbeit ist, in welchem Maße ein Ansatz basierend auf der Analyse von LiDAR-basierten Isovisten zur Lösung des "Kidnapped Robot Problems" in einer Indoor-Umgebung beitragen kann.

= Grundlage und Stand der Technik

== Das Kidnapped Robot Problem

Das "Kidnapped Robot Problem" in Innenräumen stellt eine spezielle Form des globalen Lokalisierungsproblems dar. Dabei muss der Roboter seine Position und Orientierung (Pose) ohne vorherige Kenntnis bestimmen. Dies ist eine wichtige Fähigkeit für autonome Roboter, besonders in Umgebungen ohne verlässliche GPS-Signale. Aktuelle Verfahren im Stand der Technik konzentrieren sich auf robuste und genaue Lokalisierungsmethoden, die solche drastischen Zustandsänderungen verarbeiten und eine schnelle Wiederherstellung der Lokalisierung ermöglichen können.

Im Rahmen des Stands der Technik zur Bewältigung des KRP ist die LiDAR-basierte Lokalisierung, unter Verwendung von Algorithmen wie Monte Carlo Localization (MCL), ein verbreiteter Ansatz. MCL nutzt einen Partikelfilter, um eine Wahrscheinlichkeitsverteilung über mögliche Posen zu führen und diese basierend auf der Übereinstimmung von Sensordaten mit einer vorhandenen Karte zu aktualisieren @thrun_ProbabilisticRoboticsIntelligent_2005. Obwohl effektiv, kann die Leistung von MCL in Umgebungen mit sich wiederholenden Strukturen oder wenigen Merkmalen nachlassen. Dies macht sie anfällig für das Kidnapped Robot Problem, wenn die anfängliche Posenschätzung weit von der tatsächlichen Position abweicht.

Als Alternative oder Ergänzung bei der Adressierung des KRP bieten sich Computer-Vision-Techniken an. Visuelle Platzerkennung, bei der aktuelle Kamerabilder mit einer Datenbank bekannter Orte verglichen werden, kann eine globale Posenschätzung zur Unterstützung der Relokalisierung nach einem Entführungsereignis liefern @cummins_ProbabilisticAppearanceBased_2007a. Die Kombination von visuellen und probabilistischen Lokalisierungsmethoden kann die Robustheit erhöhen, insbesondere in visuell komplexen Umgebungen.

Eine weitere Strategie zur Bewältigung des KRP ist die Kombination probabilistischer Lokalisierungsverfahren mit drahtlosen Sensordaten (wie von IMUs, funkbasierten Systemen, Bluetooth oder WLAN) @obeidat_ReviewIndoorLocalization_2021. Dieser Ansatz erhöht die Genauigkeit und liefert zusätzliche Lokalisierungsinformationen, was ebenfalls zur Robustheit bei plötzlichen Positionsänderungen beitragen kann.

Die Bewältigung des Kidnapped Robot Problems stellt somit eine zentrale Anforderung an robuste Indoor-Lokalisierungssysteme dar, und aktuelle Forschung konzentriert sich auf die Weiterentwicklung und Kombination verschiedener sensorischer Ansätze zur Verbesserung der Leistungsfähigkeit in solchen Szenarien.

== Isovisten

Isovisten werden formal definiert als "the set of all points visible from a given vantage point in space and with respect to the environment" @benedikt_takeholdspace_1979. Sie können auf verschiedene Weisen dargestellt werden, darunter Sichtbarkeitsgraphen oder Polygone für 2D und Polyeder für 3D-Repräsentationen und Polygone für 2D. Diese Darstellungen dienen als ein eindeutiger räumlicher "Fingerabdruck" für einen gegebenen Standort.

Die Forschung untersucht die Nutzung von Isovisten-Merkmalen für die Indoor-Lokalisierung. Dies beinhaltet die Entwicklung von Verfahren zur Generierung von 2D- und 3D-Isovisten aus Punktwolken, die von Sensoren wie LiDAR erfasst werden, was die Integration von Entfernungsdaten in die Isovistenanalyse ermöglicht. Darüber hinaus wird untersucht, wie Isovistenmaße die räumliche Struktur von Gebäuden erfassen und wie diese Merkmale zur Platzerkennung eingesetzt werden können, oft unter Nutzung von Methoden des maschinellen Lernens @sedlmeier_Learningindoorspace_2018.

Allerdings teilen Isovisten Herausforderungen mit anderen Lokalisierungsverfahren. Dazu gehören die Empfindlichkeit gegenüber dynamischen Umweltveränderungen (wie der Anwesenheit beweglicher Personen oder Objekte), das Risiko von Mehrdeutigkeiten in Umgebungen mit sich wiederholenden architektonischen Merkmalen sowie der rechnerische Aufwand @thrun_ProbabilisticRoboticsIntelligent_2005. Isovisten sind von diesen Schwierigkeiten betroffen.

Infolgedessen werden Isovisten aufgrund dieser Einschränkungen und ihres aktuellen Entwicklungsstands eher als komplementäre Informationen in breitere Lokalisierungs- oder Platzerkennungsframeworks integriert, anstatt als alleiniger oder primärer Lokalisierungsmechanismus zur Bewältigung von Entführungsereignissen zu dienen.


= Methodik

In diesem Kapitel wird die entwickelte Methodik zur Indoor-Lokalisierung unter Verwendung von Lidar-basierten Isovist-Merkmalen beschrieben, mit einem spezifischen Fokus auf die Bewältigung des Kidnapped Robot Problems.

== Kartengrid und Merkmalsextraktion

@conroy_dalton_isovist_2022

Die Grundlage des Lokalisierungsansatzes bildet ein Grid, das über der Umgebungskarte generiert wird. Dieses Grid repräsentiert diskrete Lokalisierungspunkte innerhalb der Arbeitsumgebung des Roboters. Die Struktur des Grids kann orthogonal sein, um eine gleichmäßige Abdeckung zu gewährleisten, oder durch eine eingeschränkte zufällige Verteilung festgelegt werden, um die rechnerische Last zu variieren oder spezifische Bereiche dichter abzudecken.

Für jeden Knoten dieses Grids wird eine Merkmalsbeschreibung erstellt. Dies erfolgt durch die Simulation eines Lidar-Scans vom jeweiligen Grid-Knoten aus. Die Simulation erzeugt eine Punktwolke, die die sichtbaren Punkte in der Umgebung aus dieser spezifischen Pose (Position und Orientierung) darstellt. Aus dieser simulierten Punktwolke werden anschließend Isovist-Merkmale extrahiert. Diese Merkmale dienen als räumlicher "Fingerabdruck" für den jeweiligen Grid-Knoten und bilden einen Datensatz bekannter Merkmale für die Lokalisierung.

== LiDAR-Scans

Während des Betriebs erfasst der Roboter kontinuierlich Lidar-Scans von seiner aktuellen, unbekannten Position aus. Diese Echtzeit-Scans liefern die notwendigen Umgebungsdaten, um die aktuelle Sicht des Roboters zu repräsentieren. Ähnlich wie bei der Merkmalsextraktion für die Grid-Knoten werden aus diesen aktuellen Lidar-Scans ebenfalls Isovist-Merkmale extrahiert.

== Relokalisierung

Die Relokalisierung des Roboters nach einem Kidnapped Robot Problem oder einem Lokalisierungsverlust basiert auf dem Vergleich der aktuellen, aus den Echtzeit-Lidar-Scans extrahierten Isovist-Merkmale mit dem Datensatz der zuvor berechneten Merkmale der Grid-Knoten.

Der Vergleich erfolgt durch eine geeignete Metrik, die die Ähnlichkeit zwischen zwei Isovist-Merkmalssätzen quantifiziert. Der Grid-Knoten, dessen Merkmale die höchste Ähnlichkeit mit den aktuellen Robotermerkmalen aufweisen, wird als Schätzung für die aktuelle Position und Orientierung des Roboters betrachtet. Durch die Suche nach der besten Übereinstimmung im vorab generierten Merkmalssatz kann der Roboter seine globale Pose bestimmen und seine Lokalisierung wiederherstellen.

Die Effizienz und Robustheit dieses Relokalisierungsprozesses hängen von der Dichte des Kartengrids, der Diskriminierungsfähigkeit der gewählten Isovist-Merkmale und der Effizienz des Vergleichsalgorithmus ab.

= Implementation

= Ergebnisse

= Diskussion

= Fazit und Ausblick

#pagebreak(weak: true)
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
#pagebreak(weak: true)
