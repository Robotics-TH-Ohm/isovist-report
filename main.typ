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

Zuverlässige und genaue Selbstlokalisierung ist ein Grundpfeiler, damit autonome mobile Roboter ihre Aufgaben effektiv in komplexen Umgebungen ausführen können. Die Kenntnis der genauen Position ist unerlässlich für Navigation, Aufgabenausführung und Interaktion mit der Umgebung. Eine signifikante Herausforderung in der mobilen Robotik stellt jedoch das sogenannte Kidnapped-Robot-Problem dar. Dieses Szenario tritt auf, wenn die Position eines Roboters unerwartet und ohne dessen Steuerung verändert wird, beispielsweise durch manuelles Versetzen an einen unbekannten Ort. In solchen Situationen verliert der Roboter seine aktuelle Positionsreferenz und muss sich auf seine Bordsensoren verlassen, um seine Position innerhalb einer vorhandenen Karte der Umgebung wiederherzustellen - ein Prozess, der als globale Lokalisierung oder Relokalisierung bezeichnet wird. Die effektive Lösung des Kidnapped-Robot-Problems ist entscheidend für die Gewährleistung der Robustheit und Zuverlässigkeit autonomer Robotersysteme in unvorhersehbaren realen Umgebungen.

Zur Lösung des Kidnapped-Robot-Problems sind Ansätze zur globalen Lokalisierung erforderlich. Etablierte probabilistische Verfahren wie die Markov-Lokalisierung @burgard_MarkovLocalizationMobile_1999 und ihre effiziente Variante, die Monte-Carlo-Lokalisierung @dellaert_MonteCarlolocalization_1999, ermöglichen dies, indem sie eine Wahrscheinlichkeitsverteilung über mögliche Roboterpositionen verwalten. Ein zentraler Aspekt ist hierbei das Perzeptionsmodell, das die Wahrscheinlichkeit von Sensordaten an einem bestimmten Ort bewertet. Die Fähigkeit dieses Modells, Orte eindeutig zu charakterisieren, ist somit entscheidend für eine erfolgreiche Relokalisierung nach einer "Entführung".

Die Entwicklung robuster und unterscheidbarer Ortsmerkmale aus Sensordaten stellt jedoch eine inhärente Herausforderung dar, insbesondere in komplexen oder dynamischen Umgebungen. Herkömmliche Ansätze zur Merkmalsextraktion können durch Rauschen, Sensorbeschränkungen oder unmodellierte dynamische Elemente beeinträchtigt werden. Dies erschwert die eindeutige Wiedererkennung von Orten und schränkt somit die Fähigkeit zur zuverlässigen Relokalisierung nach einem Kidnapping-Ereignis ein.

Um diesen Herausforderungen bei der Ortscharakterisierung zu begegnen, untersuchen wir in dieser Arbeit das Potenzial von Isovisten als Merkmalsrepräsentation für das Kidnapped-Robot-Problem. Isovisten, ursprünglich ein Konzept aus der Architekturtheorie @benedikt_takeholdspace_1979, beschreiben den von einem Standpunkt aus sichtbaren Raum und erfassen dessen geometrische Eigenschaften. Wir konzentrieren uns dabei auf die Extraktion von Isovist-Deskriptoren aus Lidar-Scans, um eine reichhaltige und strukturierte Beschreibung eines Ortes zu gewinnen, die für die Wiedererkennung genutzt werden kann.

Unsere Hypothese ist, dass die Integration von Lidar-basierten Isovist-Deskriptoren in das Perzeptionsmodell eines probabilistischen Lokalisierungsverfahrens die Fähigkeit des Roboters zur zuverlässigen Wiedererkennung von Orten verbessert. Dies gilt insbesondere für die anspruchsvolle Aufgabe der Relokalisierung nach einer "Entführung", wobei die Eignung robuster Isovist-Deskriptoren für diesen Zweck im Rahmen dieser Arbeit untersucht wird.

#pagebreak(weak: true)
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
#pagebreak(weak: true)
