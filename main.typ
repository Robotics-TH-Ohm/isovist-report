#let title = "Kidnapped Robot und Isovisten"

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

Für einen mobilen Roboter, der autonom in seiner Umgebung agieren soll, ist die Fähigkeit, seinen eigenen Standort exakt zu kennen, von fundamentaler Bedeutung. Man könnte es als die Grundvoraussetzung für jede sinnvolle Interaktion mit der Welt bezeichnen. Ohne ein zuverlässiges Wissen um die eigene Position innerhalb einer vorhandenen Umgebungskarte ist die Ausführung selbst grundlegender Aufgaben wie Navigation zu einem Zielpunkt oder die Interaktion mit Objekten schlichtweg unmöglich. Von der autonomen Reinigung über die Zustellung von Gütern bis hin zu komplexen Führungsaufgaben - all dies erfordert eine kontinuierliche und präzise Selbstverortung. Während die Lokalisierung im Außenbereich durch globale Navigationssatellitensysteme (GNSS) wie GPS weitgehend gelöst ist, stellt sie in Innenräumen nach wie vor eine signifikante Herausforderung dar.

Mit der fortschreitenden Reife der Lokalisierungsalgorithmen rückt die Forschung zunehmend komplexeren und herausfordernden Szenarien zu Leibe. Ein besonders relevantes und oft zitiertes Beispiel ist das sogenannte "Kidnapped Robot Problem" (KRP). Dieses Szenario beschreibt eine Situation, in der der Roboter unvermittelt an einen ihm unbekannten Ort innerhalb der Arbeitsumgebung versetzt wird oder aus anderen Gründen seine momentane Position vollständig verliert. Die erfolgreiche Bewältigung des KRP wird daher oft als Gradmesser für die Fähigkeit eines Roboters gesehen, sich nach einem schwerwiegenden Lokalisierungsfehler schnell und eigenständig wieder zu reorientieren und seine Arbeit fortzusetzen. Dieses Problem unterstreicht die Notwendigkeit von Lokalisierungsansätzen, die nicht nur im Normalbetrieb sondern auch in Extremfall präzise sind.

Vor diesem Hintergrund widmen wir uns in der vorliegenden Arbeit der Untersuchung eines neuartigen Ansatzes zur Indoor-Lokalisierung, der speziell für die Bewältigung des Kidnapped Robot Problems konzipiert ist. Im Mittelpunkt steht die Nutzung von Isovisten in Verbindung mit Lidar-Sensorik. Isovisten sind im Wesentlichen eine geometrische Beschreibung des sichtbaren Raums von einem bestimmten Punkt aus. Sie erfassen die Form und Struktur der unmittelbaren Umgebung, indem sie alle Punkte definieren, die vom Beobachter direkt eingesehen werden können. Dieses Konzept ist besonders relevant, da die Struktur des sichtbaren Raums eine charakteristische Signatur des Standorts liefert, die auch nach einer "Entführung" wiedererkannt werden kann. Mit Hilfe eines Lidar-Sensors lässt sich diese Isovisten-Geometrie präzise erfassen und analysieren.

Unsere zentrale Forschungsfrage, die in dieser Arbeit adressiert wird, lautet daher: In welchem Maße kann ein auf der Analyse von Lidar-basierten Isovisten basierender Ansatz dazu beitragen, das "Kidnapped Robot Problem" in einer Indoor-Umgebung robust und effizient zu lösen?

= Stand der Technik

== Das Kidnapped Robot Problem (KRP)
- symmetry problem


== Isovisten in Robotik
- Isovists like how human interact and remember shapes.


= Methodik

== 2D-LIDAR-Scans

== Extraktion von Isovist-Merkmalen

== Grid

== Relokalisierung

= Experimentet

= Ergebnisse

= Diskussion

= Fazit und Ausblick

#pagebreak(weak: true)
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
#pagebreak(weak: true)
