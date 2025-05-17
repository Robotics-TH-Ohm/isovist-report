#let title = "Kidnapped Robot Problem in Indoor-Lokalisierung mit Isovisten"

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

Mit der fortschreitenden Entwicklung von Lokalisierungsalgorithmen werden zunehmend komplexere Szenarien in der Forschung betrachtet. Ein Beispiel hierfür ist das sogenannte Kidnapped Robot Problem (KRP). Dieses Szenario beschreibt eine Situation, in der der Roboter an einen ihm unbekannten Ort innerhalb seiner Arbeitsumgebung gebracht wird oder seine aktuelle Position verliert. Die erfolgreiche Bewältigung des KRP gilt als Indikator für die Fähigkeit eines Roboters, sich nach einem Lokalisierungsfehler zu reorientieren und seine Aufgaben fortzusetzen. Dieses Problem zeigt die Anforderung an Lokalisierungsansätze, die auch in untypischen Situationen zuverlässig arbeiten.

In der vorliegenden Arbeit wird ein Ansatz zur Indoor-Lokalisierung untersucht, der auf die Bewältigung des Kidnapped Robot Problems ausgerichtet ist. Der Fokus liegt auf der Nutzung von Isovisten in Verbindung mit LiDAR-Sensorik. Isovisten beschreiben den von einem bestimmten Punkt aus sichtbaren Raum. Sie erfassen die Form und Struktur der unmittelbaren Umgebung, indem sie die direkt vom Beobachter einsehbaren Punkte definieren. Die Struktur des sichtbaren Raumes kann als charakteristisch für einen Standort betrachtet werden, was potenziell zur Wiedererkennung nach einer Positionsveränderung des Roboters genutzt werden kann. Ein LiDAR-Sensor ermöglicht die Erfassung der für die Isovisten-Analyse erforderlichen Umgebungsgeometrie.

Die zentrale Forschungsfrage dieser Arbeit ist, in welchem Maße ein Ansatz basierend auf der Analyse von LiDAR-basierten Isovisten zur Lösung des "Kidnapped Robot Problems" in einer Indoor-Umgebung beitragen kann.

= Grundlage und Stand der Technik

== Das Kidnapped Robot Problem

Das Kidnapped Robot Problem (KRP) in Innenräumen stellt eine spezielle Form des globalen Lokalisierungsproblems dar. Dabei muss der Roboter seine Position und Orientierung (Pose) ohne vorherige Kenntnis bestimmen. Dies ist eine wichtige Fähigkeit für autonome Roboter, besonders in Umgebungen ohne verlässliche GPS-Signale. Aktuelle Verfahren im Stand der Technik konzentrieren sich auf robuste und genaue Lokalisierungsmethoden, die solche drastischen Zustandsänderungen verarbeiten und eine schnelle Wiederherstellung der Lokalisierung ermöglichen können.

Im Rahmen des Stands der Technik zur Bewältigung des KRP ist die LiDAR-basierte Lokalisierung, unter Verwendung von Algorithmen wie Monte Carlo Localization (MCL), ein verbreiteter Ansatz. MCL nutzt einen Partikelfilter, um eine Wahrscheinlichkeitsverteilung über mögliche Posen zu führen und diese basierend auf der Übereinstimmung von Sensordaten mit einer vorhandenen Karte zu aktualisieren @thrun_ProbabilisticRoboticsIntelligent_2005. Obwohl effektiv, kann die Leistung von MCL in Umgebungen mit sich wiederholenden Strukturen oder wenigen Merkmalen nachlassen. Dies macht sie anfällig für das Kidnapped Robot Problem, wenn die anfängliche Posenschätzung weit von der tatsächlichen Position abweicht.

Als Alternative oder Ergänzung bei der Adressierung des KRP bieten sich Computer-Vision-Techniken an. Visuelle Platzerkennung, bei der aktuelle Kamerabilder mit einer Datenbank bekannter Orte verglichen werden, kann eine globale Posenschätzung zur Unterstützung der Relokalisierung nach einem Entführungsereignis liefern @cummins_ProbabilisticAppearanceBased_2007a. Die Kombination von visuellen und probabilistischen Lokalisierungsmethoden kann die Robustheit erhöhen, insbesondere in visuell komplexen Umgebungen.

Eine weitere Strategie zur Bewältigung des KRP ist die Kombination probabilistischer Lokalisierungsverfahren mit drahtlosen Sensordaten (wie von IMUs, funkbasierten Systemen, Bluetooth oder WLAN) @obeidat_ReviewIndoorLocalization_2021. Dieser Ansatz erhöht die Genauigkeit und liefert zusätzliche Lokalisierungsinformationen, was ebenfalls zur Robustheit bei plötzlichen Positionsänderungen beitragen kann.

Die Bewältigung des Kidnapped Robot Problems stellt somit eine zentrale Anforderung an robuste Indoor-Lokalisierungssysteme dar, und aktuelle Forschung konzentriert sich auf die Weiterentwicklung und Kombination verschiedener sensorischer Ansätze zur Verbesserung der Leistungsfähigkeit in solchen Szenarien.

== Isovisten

Isovisten werden formal definiert als "the set of all points visible from a given vantage point in space and with respect to the environment" @benedikt_takeholdspace_1979. Sie können auf verschiedene Weisen dargestellt werden, darunter Sichtbarkeitsgraphen oder Polyeder für 3D-Repräsentationen und Polygone für 2D. Diese Darstellungen dienen als ein eindeutiger räumlicher "Fingerabdruck" für einen gegebenen Standort.

Die Forschung untersucht die Nutzung von Isovisten-Merkmalen für die Indoor-Lokalisierung. Dies beinhaltet die Entwicklung von Verfahren zur Generierung von 2D- und 3D-Isovisten aus Punktwolken, die von Sensoren wie LiDAR erfasst werden, was die Integration von Entfernungsdaten in die Isovistenanalyse ermöglicht. Darüber hinaus wird untersucht, wie Isovistenmaße die räumliche Struktur von Gebäuden erfassen und wie diese Merkmale zur Platzerkennung eingesetzt werden können, oft unter Nutzung von Methoden des maschinellen Lernens @sedlmeier_Learningindoorspace_2018.

Allerdings teilen Isovisten Herausforderungen mit anderen Lokalisierungsverfahren. Dazu gehören die Empfindlichkeit gegenüber dynamischen Umweltveränderungen (wie der Anwesenheit beweglicher Personen oder Objekte), das Risiko von Mehrdeutigkeiten in Umgebungen mit sich wiederholenden architektonischen Merkmalen sowie der rechnerische Aufwand @thrun_ProbabilisticRoboticsIntelligent_2005. Isovisten sind von diesen Schwierigkeiten betroffen.

Infolgedessen werden Isovisten aufgrund dieser Einschränkungen und ihres aktuellen Entwicklungsstands eher als komplementäre Informationen in breitere Lokalisierungs- oder Platzerkennungsframeworks integriert, anstatt als alleiniger oder primärer Lokalisierungsmechanismus zur Bewältigung von Entführungsereignissen zu dienen.

= Methodik

In diesem Kapitel wird die entwickelte Methodik zur Indoor-Lokalisierung unter Verwendung von Lidar-basierten Isovist-Merkmalen beschrieben. Ein spezifischer Fokus liegt dabei auf der Bewältigung des Kidnapped Robot Problems. Die Experimente werden in einem Simulator durchgeführt, welcher den Roboter, die Umgebung und die Lidar-Sensoren umfasst.

== Kartengrid

Die Grundlage des Lokalisierungsansatzes bildet ein Grid, das über der Umgebungskarte generiert wird und diskrete Lokalisierungspunkte innerhalb der Arbeitsumgebung des Roboters repräsentiert. Für diese Arbeit wird die Karte des Sonsbeek Pavilions von Aldo van Eyck aus dem Jahr 1966 verwendet @fabrizi_SonsbeekPavilionArnhem_2013, insbesondere wegen ihrer symmetrischen Struktur. Die Symmetrie dieser Karte wurde gewählt, um die Komplexität bei der Lösung des Kidnapped Robot Problems zu erhöhen. Für diesen Ansatz stehen zwei Hauptvarianten von Grids zur Verfügung.

Die erste Variante ist ein orthogonaler Raster-Grid (auch bekannt als kartesisches Grid), das traditionell für isovist-basierte Analysen verwendet wird. Bei dieser Gridstruktur sind zwei Sätze von Linien senkrecht zueinander angeordnet (@fig:grid_ortho). Obwohl dies eine gleichmäßige Abdeckung ermöglicht, sind die Nachteile des orthogonalen Grids in Bezug auf die Ausrichtung relativ zur Gebäudestruktur, die Approximation gekrümmter Flächen und die Behandlung schmaler Öffnungen bekannt @conroy_dalton_isovist_2022. Bei der Verwendung des orthogonalen Grids kann der Abstand zwischen den Grid-Linien kontrolliert werden, was die Dichte der Lokalisierungspunkte beeinflusst.

Als zweite Variante kann eine eingeschränkte zufällige Verteilung der Grid-Knoten eingesetzt werden, angelehnt an Konzepte wie die Restricted Randomised Visibility Graph Analysis (R-VGA). Diese Methode, die darauf abzielt, eine robustere und weniger von der spezifischen Grid-Platzierung abhängige Analyse zu ermöglichen @conroy_dalton_isovist_2022, platziert die Lokalisierungspunkte nicht in einem starren Gittermuster, sondern nach einem Verfahren, das eine gleichmäßigere Verteilung gewährleistet (@fig:grid_random). Bei der eingeschränkten zufälligen Verteilung kann die Gesamtzahl der Grid-Knoten festgelegt werden, was ebenfalls die Dichte der Lokalisierungspunkte steuert.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho.png", width: 90%),
      caption: "Orthogonales Gitter",
    )<fig:grid_ortho>],
  [#figure(
      image("assets/grid_random.png", width: 90%),
      caption: "Eingeschränktes Zufallsgitter",
    )<fig:grid_random>],
)

Unten sind detaillierte Zooms an derselben Position auf der Karte für die zwei Arten von Gittern dargestellt. Dies zeigt, dass im Bereich des Kreises einige Gitterpunkte des orthogonalen Gitters aufgrund von Hindernissen nicht generiert wurden (@fig:grid_ortho_zoom). Im eingeschränkten zufälligen Gitter werden diese Punkte jedoch weiterhin angezeigt (@fig:grid_random_zoom).

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho_zoom.png", width: 70%),
      caption: "Orthogonales Gitter",
    )<fig:grid_ortho_zoom>],
  [#figure(
      image("assets/grid_random_zoom.png", width: 70%),
      caption: "Eingeschränktes Zufallsgitter",
    )<fig:grid_random_zoom>],
)

Die Wahl der Gridstruktur und die Einstellung ihrer spezifischen Parameter können somit variieren, um eine angemessene Abdeckung der Umgebung zu gewährleisten, die rechnerische Last zu steuern und die Robustheit der Lokalisierung zu optimieren.

== LiDAR-Scans und Merkmalsextraktion

Nachdem das Grid über der Umgebungskarte generiert wurde und somit die diskreten Lokalisierungspunkte festgelegt sind, wird für jeden dieser Grid-Knoten eine Merkmalsbeschreibung basierend auf simulierten Lidar-Scans erstellt. Hierzu wird für jeden einzelnen Grid-Knoten ein Lidar-Scan von seiner spezifischen Position aus simuliert. Diese Simulation erzeugt eine Punktwolke, welche die sichtbaren Umgebungsmerkmale aus der Perspektive des jeweiligen Grid-Knotens darstellt.

Aus dieser simulierten Punktwolke werden anschließend verschiedene Isovist-Merkmale extrahiert. Diese Merkmale quantifizieren unterschiedliche Aspekte der sichtbaren Fläche und dienen als räumlicher "Fingerabdruck" für jeden Grid-Knoten. Es werden die folgenden Isovist-Merkmale verwendet:

*Fläche:* Dieses Merkmal repräsentiert die gesamte sichtbare Fläche vom jeweiligen Standpunkt aus. Die Fläche des Isovist-Polygons wird unter Verwendung des Shoelace-Algorithmus berechnet:

$ "Fläche" = 1 / 2 abs(sum^N_(i=1) x_i (y_i+1 - y_y-1)) $

*Umfang:* Dieses Merkmal beschreibt die Gesamtlänge der Begrenzungslinie des Isovists. Der Umfang des Isovist-Polygons ist die Summe der Längen seiner Begrenzungssegmente:
$ "Umfang" = sum^N_(i=1) sqrt((x_(i+1)-x_i)^2 + (y_(i+1)-y_i)^2) $

*Kompaktheit:* Dieses Merkmal gibt ein Maß dafür an, wie "kreisförmig" die sichtbare Fläche ist. Die Kompaktheit ist ein dimensionsloses Maß, definiert als:
$ "Kompaktheit" = (4 pi "Fläche") / "Umfang"^2 $

*Drift:* Dieses Merkmal repräsentiert die Distanz vom Standpunkt $(v_x, v_y)$ zum Schwerpunkt $(c_x, c_y)$ des Isovist-Polygons. Die Schwerpunktkoordinaten werden berechnet als:
$ "Drift" = sqrt((c_x - v_x)^2 + (c_y - v_y)^2) $

*Radiale Längen (Min, Mittelwert, Max, Sequenz):* Diese Merkmale basieren auf den Distanzen vom Standpunkt zu den Eckpunkten des Isovists. Sei $r_i$ die radiale Distanz vom Standpunkt $(v_x, v_y)$ zum $i$-ten Eckpunkt $(x_i, y_i)$. Diese Distanz wird wie folgt berechnet:

$ r_i = sqrt((x_i - v_x)^2 + (y_i - v_y)^2) $

Die radialen Längenmerkmale, abgeleitet von der oben definierten Distanz $r_i$, sind wie folgt definiert:

- Radiale Länge Min:
$ "Radiale Länge Min" = min(r_1, r_2, ..., r_N) $

- Radiale Länge Mittelwert:
$ "Radiale Länge Mittelwert" = 1 / N sum^N_(i=1) r_i $

- Radiale Länge Max:
$ "Radiale Länge Max" = max(r_1, r_2, ..., r_N) $

- Radiale Längensequenz:
$ "Radiale Längensequenz" = [r_1, r_2, ..., r_N] $

#v(0.5em)

*Radiale Momente (Mittelwert, Varianz, Schiefe):* Die radialen Momente quantifizieren Eigenschaften der sichtbaren Fläche basierend auf der Verteilung des radialen Abstands vom Standpunkt zur Isovist-Begrenzung. Für ein polygonales Isovist werden die rohen radialen Momente $M_1, M_2, M_3$ wie folgt berechnet:

- Radial Mittelwert
$ "Radial Moment Mittelwert" = M_1 = a_1 $

- Radial Moment Varianz
$ "Radial Moment Varianz" = M_2 = a_2 - M_1^2 $

- Radial Moment Schiefe
$ "Radial Moment Schiefe" = M_3 = a_3 - 3 M_1 a_2 + 2 M_1^3 $

wobei die Terme $a_1, a_2, a_3$ sich auf die Summe über alle Begrenzungssegmente $i$ des Isovist-Polygons beziehen und wie folgt definiert sind:

- $a_1 = sum^N_(i=1) a_1(i)$

- $a_2 = sum^N_(i=1) a_2(i)$

- $a_3 = sum^N_(i=1) a_3(i)$

Die einzelnen Terme $a_1(i), a_2(i), a_3(i)$ für das $i$-te Begrenzungssegment werden berechnet als:

- $a_1(i) = (a_i b_i) / c_i (sin gamma_i) / gamma_i log abs(((c_i+a_i - b cos gamma_i)(c_i + b_i - a_i cos gamma_i)) / (a_i b_i sin^2 gamma_i))$

- $a_2(i) 1 / gamma_i ((a_i b_i) / c_i sin gamma_i)^2 ( cot alpha_i + cot beta_i)$

- $a_3(i) = 1 / 2 gamma_i ((a_i b_i ) / c_i sin gamma_i)^3 [csc alpha_i cot alpha_i + csc beta_i cot beta_i + \ #h(16em) log abs((csc alpha_i + cot alpha_i)(csc beta_i + cot beta_i)) ]$

Die geometrischen Parameter Seitenlängen ($a_i, b_i, c_i$) und Winkel ($alpha_i, beta_i, gamma_i$) beziehen sich auf das Dreieck, das durch den Standpunkt und das $i$-te Begrenzungssegment gebildet wird.

Diese extrahierten Isovist-Merkmale werden zusammen mit der Position des jeweiligen Knotens im Arbeitsspeicher gespeichert. Dies bildet den Datensatz bekannter Merkmale, der für die nachfolgende Lokalisierung benötigt wird.

== Relokalisierung

Die Effizienz und Robustheit dieses Relokalisierungsprozesses hängen von der Dichte des Kartengrids, der Diskriminierungsfähigkeit der gewählten Isovist-Merkmale und der Effizienz des Vergleichsalgorithmus ab. Nachdem die Isovist-Merkmale sowohl für die generierten Grid-Knoten (basierend auf Simulationen) als auch für den aktuellen Lidar-Scan des Roboters extrahiert wurden (@fig:isovists_features), besteht der nächste Schritt darin, die Ähnlichkeit zwischen dem aktuellen Merkmalsvektor des Roboters und den gespeicherten Merkmalsvektoren jedes Grid-Knotens zu bestimmen.

Diese Ähnlichkeitsbestimmung erfolgt mithilfe einer geeigneten Distanzfunktion. Durch die Berechnung der Distanz zwischen den Merkmalsvektoren kann quantifiziert werden, wie ähnlich die aktuelle Sicht des Roboters der simulierten Sicht an jedem einzelnen Grid-Knoten ist. Für diesen Zweck können verschiedene Distanzfunktionen eingesetzt werden, darunter die euklidische Distanz, die Kosinus-Ähnlichkeit und die Manhattan-Distanz. Die Wahl der Distanzfunktion kann die Interpretation von Ähnlichkeit im Merkmalsraum beeinflussen und sollte auf die Eigenschaften der verwendeten Isovist-Merkmale abgestimmt sein.

Der Grid-Knoten, dessen Merkmalsvektor die geringste Distanz (oder höchste Ähnlichkeit) zum aktuellen Merkmalsvektor des Roboters aufweist, wird als die wahrscheinlichste Position des Roboters angenommen. Die Position des Roboters wird somit auf den Ort dieses am besten passenden Grid-Knotens im Kartengrid geschätzt.

#figure(
  image("assets/features.png", width: 100%),
  caption: "Karte mit Isovisten Merkmalen",
)<fig:isovists_features>

= Implementation

JAVA Carbot Simulator

= Ergebnisse

TODO: Testen

= Diskussion

= Fazit und Ausblick

#pagebreak(weak: true)
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
#pagebreak(weak: true)
