#let title = "Kidnapped Robot Problem:\nIndoor-Lokalisierung mit Isovisten"

#let authors = (
  (name: "Tan Phat Nguyen", email: "nguyenta100556@th-nuernberg.de"),
  (name: "Nils Weber", email: "weberni76153@th-nuernberg.de"),
)

#set document(
  title: title.replace("\n", " "),
  author: authors.map(author => author.name).join(", "),
  description: "DRAFT - Version 2025-05-22",
)

#set text(font: "New Computer Modern", lang: "de", size: 12pt)

#set page(
  paper: "a4",
  margin: (right: 2.5cm, left: 2.5cm, top: 2.5cm, bottom: 2cm),
  header: context if counter(page).get().at(0) > 1 { text(size: 10pt, title.replace("\n", " ")) } else {
    text(font: "DejaVu Sans Mono", weight: "bold", fill: rgb("#c72426"))[DRAFT --- Version 2025-05-22]
  },
  footer: text(size: 10pt, context counter(page).display()),
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

#grid(
  columns: authors.len(),
  column-gutter: 4em,
  rows: 1,

  ..authors.map(author => [
    *#author.name*\
    #link("mailto:" + author.email)
  ])
)

#v(1em)

#set align(top + left)

#set par(justify: true)

#show regex("(?i)lidar"): [LiDAR]

= Einleitung

Die Fähigkeit mobiler Roboter zur autonomen Bewegung in ihrer Umgebung erfordert die exakte Kenntnis des eigenen Standorts. Diese Selbstlokalisierung ist die Grundlage für sinnvolle Interaktionen mit der Umgebung. Ein Roboter benötigt eine präzise Positionsbestimmung auf einer Karte, da die Erledigung von Aufgaben andernfalls erheblich erschwert oder unmöglich ist. Anwendungen wie autonome Reinigung, Güterzustellung oder Führungsaufgaben setzen eine kontinuierliche und genaue Selbstverortung voraus. Während die Lokalisierung im Außenbereich durch globale Navigationssatellitensysteme (GNSS) wie GPS weitgehend etabliert ist, bleibt sie in Innenräumen eine signifikante Herausforderung.

Mit der fortschreitenden Entwicklung von Lokalisierungsalgorithmen werden zunehmend komplexere Szenarien in der Forschung betrachtet. Ein Beispiel hierfür ist das sogenannte Kidnapped Robot Problem (KRP). Dieses Szenario beschreibt eine Situation, in der der Roboter an einen ihm unbekannten Ort innerhalb seiner Arbeitsumgebung gebracht wird oder seine aktuelle Position verliert. Die erfolgreiche Bewältigung des KRP gilt als Indikator für die Fähigkeit eines Roboters, sich nach einem Lokalisierungsfehler zu reorientieren und seine Aufgaben fortzusetzen. Dieses Problem zeigt die Anforderung an Lokalisierungsansätze, die auch in untypischen Situationen zuverlässig arbeiten.

In der vorliegenden Arbeit wird ein Ansatz zur Indoor-Lokalisierung untersucht, der auf die Bewältigung des Kidnapped Robot Problems ausgerichtet ist. Der Fokus liegt auf der Nutzung von Isovisten in Verbindung mit LiDAR-Sensorik. Isovisten beschreiben den von einem bestimmten Punkt aus sichtbaren Raum. Sie erfassen die Form und Struktur der unmittelbaren Umgebung, indem sie die direkt vom Beobachter einsehbaren Punkte definieren. Die Struktur des sichtbaren Raumes kann als charakteristisch für einen Standort betrachtet werden, was potenziell zur Wiedererkennung nach einer Positionsveränderung des Roboters genutzt werden kann. Ein LiDAR-Sensor ermöglicht die Erfassung der für die Isovisten-Analyse erforderlichen Umgebungsgeometrie.

Die zentrale Forschungsfrage dieser Arbeit ist, in welchem Maße ein Ansatz basierend auf der Analyse von LiDAR-basierten Isovisten zur Lösung des Kidnapped Robot Problems in einer Indoor-Umgebung beitragen kann.

= Grundlagen und Stand der Technik

In diesem Kapitel wird das Kidnapped Robot Problem beschrieben sowie aktuelle Herangehensweisen daran erläutert, die sich vorrangig auf die Fusion verschiedener Sensordaten konzentrieren. Die detaillierte Betrachtung von Isovisten ermöglicht es, eine alternative Lösungsstrategie zu skizzieren, welche diese als primäre Quelle zur Lokalisierung nutzt.

== Das Kidnapped Robot Problem

Das Kidnapped Robot Problem (KRP) in Innenräumen stellt eine spezielle Form des globalen Lokalisierungsproblems dar. Dabei muss der Roboter seine Position und Orientierung (Pose) ohne vorherige Kenntnis bestimmen. Dies ist eine wichtige Fähigkeit für autonome Roboter, insbesondere in Umgebungen ohne verlässliche GPS-Signale. Aktuelle Verfahren konzentrieren sich auf robuste und genaue Lokalisierungsmethoden, die solche drastischen Zustandsänderungen verarbeiten und eine schnelle Wiederherstellung der Lokalisierung ermöglichen.

Im Rahmen des Stands der Technik zur Bewältigung des KRP ist die LiDAR-basierte Lokalisierung unter Verwendung von Algorithmen wie Monte Carlo Localization (MCL) ein verbreiteter Ansatz. MCL nutzt einen Partikelfilter, um eine Wahrscheinlichkeitsverteilung über mögliche Posen zu führen und diese basierend auf der Übereinstimmung von Sensordaten mit einer vorhandenen Karte zu aktualisieren @thrun_ProbabilisticRoboticsIntelligent_2005. Ein Vorteil von MCL ist, dass es Rohsensormessungen direkt verarbeiten kann und nicht nur für eine einzige, genaue Position geeignet ist. Es ist somit prinzipiell in der Lage, globale Lokalisierungsprobleme sowie das Kidnapped Robot Problem zu lösen @thrun_ProbabilisticRoboticsIntelligent_2005.

Obwohl MCL grundsätzlich wirksam ist, kann seine Leistung in Umgebungen mit sich wiederholenden Strukturen oder wenigen einzigartigen Merkmalen abnehmen. Dies macht MCL anfällig für das Kidnapped Robot Problem, insbesondere wenn die anfängliche Positionsschätzung stark von der tatsächlichen Lage abweicht oder ein kompletter Lokalisierungsverlust eintritt. Um das KRP mit MCL zu bewältigen, werden spezifische Techniken angewandt. Eine gängige Methode ist das Hinzufügen zufälliger Partikel zum Partikelsatz. Diese Maßnahme erhöht die Robustheit des Algorithmus, indem sie eine kontinuierliche Neuinitialisierung der Lokalisierung ermöglicht, als würde der Roboter mit einer kleinen Wahrscheinlichkeit unerwartet "entführt" worden sein @thrun_ProbabilisticRoboticsIntelligent_2005. Ein weiterer Ansatz ist das Mixture MCL, das eine robuste Lösung für das KRP bietet. Hierbei werden Partikel an Orten platziert, die basierend auf der jüngsten Messung plausibel erscheinen, was eine verbesserte Robustheit in praktischen Anwendungen gewährleistet @thrun_ProbabilisticRoboticsIntelligent_2005.

Als Alternative oder Ergänzung zur Bewältigung des KRP können Computer-Vision-Techniken eingesetzt werden. Die visuelle Platzerkennung, bei der aktuelle Kamerabilder mit einer Datenbank bekannter Orte verglichen werden, kann eine globale Positionsschätzung liefern und so die erneute Lokalisierung nach einem "Entführungsereignis" unterstützen @cummins_ProbabilisticAppearanceBased_2007a. Die Kombination von visuellen und probabilistischen Lokalisierungsmethoden kann die Robustheit erhöhen, insbesondere in visuell komplexen Umgebungen.

Eine weitere Strategie zur Bewältigung des KRP ist die Kombination probabilistischer Lokalisierungsverfahren mit drahtlosen Sensordaten (wie von IMUs, funkbasierten Systemen, Bluetooth oder WLAN) @obeidat_ReviewIndoorLocalization_2021. Dieser Ansatz kann die Genauigkeit verbessern und zusätzliche Lokalisierungsinformationen bereitstellen, was ebenfalls zur Robustheit bei plötzlichen Positionsänderungen beitragen kann.

Die Bewältigung des Kidnapped Robot Problems stellt somit eine zentrale Anforderung an robuste Indoor-Lokalisierungssysteme dar. Die aktuelle Forschung konzentriert sich dabei auf die Weiterentwicklung und Kombination verschiedener sensorischer Ansätze, um die Leistungsfähigkeit in solchen Szenarien zu verbessern.

== Isovisten

#figure(
  image("assets/isovist.png", width: 80%),
  caption: "Visueller Bereich (Isovisten) von einem Standpunkt aus in einer Umgebung",
) <fig:isovist>

Isovisten werden formal definiert als "the set of all points visible from a given vantage point in space and with respect to the environment" @benedikt_takeholdspace_1979. Wie in @fig:isovist dargestellt, entsteht von einem Standpunkt (roter Punkt) aus die sichtbare Fläche (grün schraffierte Fläche). Die nicht sichtbaren Bereiche (weiße Fläche) werden durch Wände begrenzt. Isovisten können auf verschiedene Weisen dargestellt werden, darunter Sichtbarkeitsgraphen oder Polyeder für 3D-Repräsentationen und Polygone im zweidimensionalen Bereich. Diese Darstellungen dienen als ein eindeutiger räumlicher "Fingerabdruck" für einen gegebenen Standort.

Die Forschung untersucht die Nutzung von Isovisten-Merkmalen für die Indoor-Lokalisierung. Dies beinhaltet die Entwicklung von Verfahren zur Generierung von 2D- und 3D-Isovisten aus Punktwolken, die von Sensoren wie LiDAR erfasst werden. Darüber hinaus wird analysiert, wie Isovistenmaße die räumliche Struktur von Gebäuden erfassen und wie diese Merkmale zur Platzerkennung eingesetzt werden können, oft unter Nutzung von Methoden des maschinellen Lernens @sedlmeier_Learningindoorspace_2018.

Allerdings teilen Isovisten Herausforderungen mit anderen Lokalisierungsverfahren. Dazu gehören die Empfindlichkeit gegenüber dynamischen Umweltveränderungen (wie der Anwesenheit von Personen oder beweglichen Objekten), das Risiko von Mehrdeutigkeiten in Umgebungen mit sich wiederholenden architektonischen Merkmalen sowie der rechnerische Aufwand @thrun_ProbabilisticRoboticsIntelligent_2005. Isovisten sind von diesen Schwierigkeiten ebenfalls betroffen.

Infolgedessen werden Isovisten aufgrund dieser Einschränkungen und ihres aktuellen Entwicklungsstands eher als komplementäre Informationen in breitere Lokalisierungs- oder Platzerkennungsframeworks integriert, anstatt als alleiniger oder primärer Lokalisierungsmechanismus zur Bewältigung von Entführungsereignissen zu dienen.

= Methodik zur Bewältigung des Kidnapped Robot Problems mittels Isovisten

In diesem Kapitel wird die entwickelte Methodik zur Bewältigung des Kidnapped Robot Problems unter Verwendung von Lidar-basierten Isovisten-Merkmalen für die Indoor-Lokalisierung beschrieben. Die Experimente werden in einem Simulator durchgeführt, welcher den Roboter, die Umgebung und die LiDAR-Sensoren umfasst. Um das Kidnapped Robot Problem zu untersuchen, können die LiDAR-Sensoren zudem an beliebigen Stellen platziert werden, und die Umgebung ist statisch.

== Kartengrid

Die Grundlage des Lokalisierungsansatzes bildet ein Grid, das über der Umgebungskarte generiert wird und diskrete Lokalisierungspunkte innerhalb der Arbeitsumgebung des Roboters repräsentiert. Für diese Arbeit wird die Karte des Sonsbeek Pavilions von Aldo van Eyck aus dem Jahr 1966 verwendet @fabrizi_SonsbeekPavilionArnhem_2013. Diese Karte zeichnet sich nicht nur durch ihre symmetrische Struktur aus, sondern beinhaltet auch verschiedene kreisförmige Linien. Die Symmetrie und die komplexen geometrischen Formen dieser Karte wurden gewählt, um die Komplexität bei der Lösung des Kidnapped Robot Problems zu erhöhen. Für diesen Ansatz stehen zwei Hauptvarianten von Grids zur Verfügung.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho.png", width: 90%),
      caption: "Orthogonales Grid",
    )<fig:grid_ortho>],
  [#figure(
      image("assets/grid_random.png", width: 90%),
      caption: "Eingeschränktes Zufalls-Grid",
    )<fig:grid_random>],
)

Die erste Variante ist ein orthogonales Grid (auch bekannt als kartesisches Grid), das traditionell für isovisten-basierte Analysen verwendet wird. Bei dieser Gridstruktur sind zwei Sätze von Linien senkrecht zueinander angeordnet (@fig:grid_ortho). Obwohl dies eine gleichmäßige Abdeckung ermöglicht, sind die Nachteile des orthogonalen Grids in Bezug auf die Ausrichtung relativ zur Gebäudestruktur, die Approximation gekrümmter Flächen und die Behandlung schmaler Öffnungen bekannt @conroy_dalton_isovist_2022. Bei der Verwendung des orthogonalen Grids kann der Abstand zwischen den Grid-Linien kontrolliert werden, was die Dichte der Lokalisierungspunkte beeinflusst.

Als zweite Variante kann eine eingeschränkte zufällige Verteilung der Grid-Knoten eingesetzt werden, angelehnt an Konzepte wie die Restricted Randomised Visibility Graph Analysis (R-VGA). Diese Methode, die darauf abzielt, eine robustere und weniger von der spezifischen Grid-Platzierung abhängige Analyse zu ermöglichen @conroy_dalton_isovist_2022, platziert die Lokalisierungspunkte nicht in einem starren Gridmuster, sondern nach einem Verfahren, das eine gleichmäßigere Verteilung gewährleistet (@fig:grid_random). Bei der eingeschränkten zufälligen Verteilung kann die Gesamtzahl der Grid-Knoten festgelegt werden, was ebenfalls die Dichte der Lokalisierungspunkte steuert.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho_zoom.png", width: 70%),
      caption: "Orthogonales Grid: Punkte können in Hindernissen oder zu nahe an ihnen liegen.",
    )<fig:grid_ortho_zoom>],
  [#figure(
      image("assets/grid_random_zoom.png", width: 70%),
      caption: "Eingeschränktes Zufalls-Grid: Die Pfeile markieren Punkte, die im orthogonalen Grid nicht erzeugt würden.",
    )<fig:grid_random_zoom>],
)

Durch die immer in gleichen Abständen platzierten Punkte eines orthogonalen Grids ist es möglich, dass diese häufig zu nahe an oder innerhalb von Hindernissen generiert werden (@fig:grid_ortho_zoom). Solche Punkte sind dann nicht zur Berechnung eines Isovisten verwendbar. Im eingeschränkten zufälligen Grid kann dies vermieden werden, da die Gridpunkte nicht an ein fest definiertes Raster gebunden sind. Wie in @fig:grid_random_zoom gezeigt, illustrieren zwei Punkte, die im orthogonalen Grid nicht generiert, aber im eingeschränkten zufälligen Grid verfügbar sind.

Die Wahl der Gridstruktur und die Einstellung ihrer spezifischen Parameter können somit variiert werden, um eine angemessene Abdeckung der Umgebung zu gewährleisten, die rechnerische Last zu steuern und die Robustheit der Lokalisierung zu optimieren.

== LiDAR-Scans und Merkmalsextraktion <sec:merkmale>

Nachdem das Grid über der Umgebungskarte generiert und somit die diskreten Lokalisierungspunkte festgelegt wurden, wird für jeden dieser Grid-Knoten eine Merkmalsbeschreibung basierend auf simulierten LiDAR-Scans erstellt. Hierzu wird für jeden einzelnen Grid-Knoten ein LiDAR-Scan von seiner spezifischen Position aus simuliert. Diese Simulation erzeugt eine Punktwolke, welche die sichtbaren Umgebungsmerkmale aus der Perspektive des jeweiligen Grid-Knotens darstellt.

#figure(
  image("assets/features.png", width: 90%),
  caption: "Beispiele von Isovisten-Merkmalen auf einer Umgebungskarte.",
)<fig:isovists_features>

Aus den simulierten LiDAR-Scans, die für jeden Grid-Knoten erstellt werden, werden anschließend verschiedene Isovisten-Merkmale extrahiert. Diese Merkmale quantifizieren unterschiedliche Aspekte der jeweiligen sichtbaren Fläche und dienen als räumlicher "Fingerabdruck" für den jeweiligen Grid-Knoten, wie in @fig:isovists_features exemplarisch dargestellt. Es werden die folgenden Isovisten-Merkmale verwendet:

*Fläche:* Dieses Merkmal repräsentiert die gesamte sichtbare Fläche vom jeweiligen Standpunkt aus. Die Fläche des Isovisten-Polygons wird unter Verwendung des Shoelace-Algorithmus berechnet:

$ "Fläche" = 1 / 2 abs(sum^N_(i=1) x_i (y_i+1 - y_y-1)) $

*Umfang:* Dieses Merkmal beschreibt die Gesamtlänge der Begrenzungslinie des Isovisten. Der Umfang des Isovisten-Polygons ist die Summe der Längen seiner Begrenzungssegmente:
$ "Umfang" = sum^N_(i=1) sqrt((x_(i+1)-x_i)^2 + (y_(i+1)-y_i)^2) $

*Kompaktheit:* Dieses Merkmal gibt ein Maß dafür an, wie "kreisförmig" die sichtbare Fläche ist. Die Kompaktheit ist ein dimensionsloses Maß, definiert als:
$ "Kompaktheit" = (4 pi dot "Fläche") / "Umfang"^2 $

*Drift:* Dieses Merkmal repräsentiert die Distanz vom Standpunkt $(v_x, v_y)$ zum Schwerpunkt $(c_x, c_y)$ des Isovisten-Polygons:
$ "Drift" = sqrt((c_x - v_x)^2 + (c_y - v_y)^2) $

Die Schwerpunktkoordinaten $(c_y, c_y)$ werden berechnet als:

$ c_x = 1 / (6 dot "Fläche") sum^N_(i=1) (x_i + x_(i+1)) p $
$ c_y = 1 / (6 dot "Fläche") sum^N_(i=1) (y_i + y_(i+1)) p $
$ p = sum^N_(i=1) (x_i dot y_(i+1) - x_(i+1) dot y_i) $

*Radiale Längen (Mininimum, Mittelwert, Maximum, Sequenz):* Diese Merkmale basieren auf den Distanzen vom Standpunkt zu den Eckpunkten des Isovisten. Sei $r_i$ die radiale Distanz vom Standpunkt $(v_x, v_y)$ zum $i$-ten Eckpunkt $(x_i, y_i)$. Diese Distanz wird wie folgt berechnet:

$ r_i = sqrt((x_i - v_x)^2 + (y_i - v_y)^2) $

Die radialen Längenmerkmale $R$, abgeleitet von der oben definierten Distanz $r_i$, sind wie folgt definiert:

$
  R_("min") &= min(r_1, r_2, ..., r_N) \
  R_("avg") &= 1 / N sum^N_(i=1) r_i \
  R_("max") &= max(r_1, r_2, ..., r_N) \
  R_("seq") &= [r_1, r_2, ..., r_N]
$

#v(0.5em)

*Radiale Momente (Mittelwert, Varianz, Schiefe):* Die radialen Momente quantifizieren Eigenschaften der sichtbaren Fläche basierend auf der Verteilung des radialen Abstands vom Standpunkt zur Isovisten-Begrenzung. Für einen polygonalen Isovisten werden die rohen radialen Momente $M_1, M_2, M_3$ wie folgt berechnet:

$
  M_("avg") &= a_1 \
  M_("var") &= a_2 - M_("avg")^2 \
  M_("skew") &= a_3 - 3 M_("avg") a_2 + 2 M_("avg")^3
$

wobei die Terme $a_1, a_2, a_3$ sich auf die Summe über alle Begrenzungssegmente $i$ des Isovisten-Polygons beziehen und wie folgt definiert sind:

$
  a_1 = sum^N_(i=1) a_1(i) #h(4em)
  a_2 = sum^N_(i=1) a_2(i) #h(4em)
  a_3 = sum^N_(i=1) a_3(i)
$

Die einzelnen Terme $a_1(i), a_2(i), a_3(i)$ für das $i$-te Begrenzungssegment werden berechnet als:

$
  a_1(i) &= (a_i b_i) / c_i (sin gamma_i) / gamma_i log abs(((c_i+a_i - b cos gamma_i)(c_i + b_i - a_i cos gamma_i)) / (a_i b_i sin^2 gamma_i)) \
  a_2(i) &= 1 / gamma_i ((a_i b_i) / c_i sin gamma_i)^2 ( cot alpha_i + cot beta_i) \
  a_3(i) &= 1 / 2 gamma_i ((a_i b_i ) / c_i sin gamma_i)^3 [csc alpha_i cot alpha_i + csc beta_i cot beta_i + \ &#h(9em) log abs((csc alpha_i + cot alpha_i)(csc beta_i + cot beta_i)) ]
$

#figure(
  image("assets/isovist_triangle.png", width: 90%),
  caption: "Segment-Dreieck mit Standpunkt und Isovisten-Eckpunkten.",
)<fig:isovist_triangle>

Die geometrischen Parameter für Seitenlängen ($a_i, b_i, c_i$) und Winkel ($alpha_i, beta_i, gamma_i$) beziehen sich auf das Segment-Dreieck, das durch den Standpunkt und die beiden benachbarten Eckpunkte des Isovisten-Polygons gebildet wird (siehe @fig:isovist_triangle).

Diese extrahierten Isovisten-Merkmale werden als Vektor zusammen mit der Position des jeweiligen Knotens gespeichert. Dies bildet den Datensatz bekannter Merkmale, der für die Relokalisierung nach einem Kidnapping des Roboters benötigt wird.

== Relokalisierung

Die Effizienz und Robustheit dieses Relokalisierungsprozesses hängen von der Dichte des Kartengrids, der Diskriminierungsfähigkeit der gewählten Isovisten-Merkmale und der Effizienz des Vergleichsalgorithmus ab. Nachdem die Isovisten-Merkmale sowohl für die generierten Grid-Knoten (basierend auf Simulationen) als auch für den aktuellen LiDAR-Scan des Roboters extrahiert wurden, besteht der nächste Schritt darin, die Ähnlichkeit zwischen dem aktuellen Merkmalsvektor des Roboters und den gespeicherten Merkmalsvektoren jedes Grid-Knotens zu bestimmen.

Diese Ähnlichkeitsbestimmung erfolgt mithilfe einer geeigneten Distanzfunktion. Zuvor werden jedoch alle Merkmalswerte der Isovisten-Vektoren normalisiert, typischerweise auf einen Wertebereich von 0 bis 1. Dies gewährleistet, dass einzelne Merkmale aufgrund ihrer Wertebereiche keine übermäßige Dominanz im Vergleichsprozess erhalten. Durch die Berechnung der Distanz zwischen den normalisierten Merkmalsvektoren kann quantifiziert werden, wie ähnlich die aktuelle Sicht des Roboters der simulierten Sicht an jedem einzelnen Grid-Knoten ist. Für diesen Zweck können verschiedene Distanzfunktionen eingesetzt werden, darunter die euklidische Distanz, die Kosinus-Ähnlichkeit und die Manhattan-Distanz. Die Wahl der Distanzfunktion kann die Interpretation von Ähnlichkeit im Merkmalsraum beeinflussen und sollte auf die Eigenschaften der verwendeten Isovisten-Merkmale abgestimmt sein.

Der Grid-Knoten, dessen Merkmalsvektor die geringste Distanz (oder höchste Ähnlichkeit) zum aktuellen Merkmalsvektor des Roboters aufweist, wird als dessen wahrscheinlichste Position angenommen. Die Position des Roboters wird somit auf den Ort dieses am besten passenden Grid-Knotens im Kartengrid geschätzt.

= Implementation

Die vorgestellte Methodik wird innerhalb des Carbot-Simulators umgesetzt, um die Robustheit der Lokalisierungsstrategie auf realitätsnah simulierten Lidar-Messungen testen zu können.
Der virtuelle Lidar-Sensor besitzt eine Auflösung von 0,9° mit einer maximalen Sichtweite von sechs Metern.
Somit werden für einen 360°-Scan insgesamt 400 Messungen erzeugt.
Da diese z. B. durch Reflexion oder aufgrund der Sichtweite ungültig sind, ist die tatsächlich nutzbare Anzahl an Messungen in der Regel geringer.

== Kartografieren der Umgebung

Zu Beginn ist die Arbeitsumgebung des Roboters zu kartografieren.
Hierzu wird eine Menge an in der Umgebung vorhandenen Hindernispunkten benötigt.
Diese kann einerseits durch dedizierte Messungen im Rahmen einer Kartografie-Aufgabe durch den Roboter generiert oder aus aus der manuellen Definition einer Karte der Arbeitsumgebung abgeleitet werden.
Die gesammelten Hindernispunkte werden als Punktwolke repräsentiert.

Die Grundlage der Umgebungskarte bildet ein orthognoales Gitter über der Arbeitsumgebung, wobei eine Zellengröße bzw. Gitterknotenabstand in der Breite des Roboters gewählt wird.
Hierdurch kann die Lokalisierung auf einen maximalen Fehler in Höhe der halben Roboterbreite betrieben werden, was für diese Arbeit als ausreichend genau betrachtet wird.
Die gesammelten Hindernispunkte werden anschließend in das Grid eingetragen, wobei jede Zelle, welche von einem Hindernispunkt getroffen wird, als nicht befahrbar zu betrachten ist.
Zur Ermittlung aller durch den Roboter erreichbarer Zellen wird ausgehend von einer beliebigen erreichbaren Zelle (z. B. die nach der Kartografier-Fahrt bekannte Position des Roboters) radial auswärts jede Zelle markiert, welche von dieser erreichbar und kein Hindernis ist.
Ein möglicher Algorithmus ist in @alg:reachable gezeigt, wobei ausgehend von Startzelle $s$ unter Berücksichtigung der Hindernisse $H$ alle erreichbaren Zellen $R$ ermittelt werden.
Für diese Menge gilt es, Isovisten-Merkmale zu berechnen.

#import "@preview/algorithmic:1.0.0"
#import algorithmic: algorithm-figure, style-algorithm

#show: style-algorithm // Do not forget!

#algorithm-figure(
  [Ermittlung aller erreichbaren Zellen],
  supplement: [Algorithmus],
  kind: "algorithm",
  placement: none,

  {
    import algorithmic: *
    Function(
      "Erreichbar",
      ("H", "s"),
      {
        LineComment(Assign[$R$][${}$], [Menge erreichbarer Zellen])
        LineComment(Assign[$Q$][${s}$], [Menge zu überprüfender Zellen])
        LineBreak
        While(
          $Q != {}$,
          {
            LineComment(Assign([c], [$Q$.pop()]), [Nehme nächste Zelle aus der Queue])
            If(
              $c in.not H and c in.not R$,
              {
                Comment[Zelle ist kein Hindernis und wurde noch nicht betrachtet]
                LineComment(Assign[$R$][$R union c$], [Markiere Zelle als erreichbar])
                LineComment(
                  Assign[$Q$][$Q union {"c.north()", "c.east()", "c.south()", "c.west()"}$],
                  [Betrachte alle Nachbarn],
                )
              },
            )
          },
        )
        Return[$R$]
      },
    )
  },
) <alg:reachable>

@fig:environment zeigt die in der Simulation verwendete Umgebung, welche nach Eintragen der Hindernispunkte als Grid approximiert ist (@fig:grid).
Rote Zellen sind dabei von Hindernissen betroffen, während grüne Zellen als erreichbar markiert sind.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/environment.png", width: 90%),
      caption: [Umgebung des Roboters],
    )<fig:environment>],
  [#figure(
      image("assets/grid.png", width: 90%),
      caption: [Approximation der Umgebung als Grid],
    )<fig:grid>],
)

== Berechnung der Isovisten-Merkmale

Zur Extraktion der Merkmale eines Isovisten werden ausgehend von der aktuellen Position $(v_x, v_y)$ auf dem Gitter alle Punkte innerhalb des Sichtbarkeitsradius ermittelt.
Der Roboter sucht dazu radial im Abstand von 0.9° (angelehnt an die Genauigkeit des Lidar-Sensors) jeweils nach dem am nähesten liegenden Hindernispunkt.
Wird keiner gefunden, so wird davon ausgegangen, dass der Roboter nicht weit genug "sehen" konnte, um auf einen Hindernispunkt zu treffen.
Um trotzdem einen nutzbaren Isovisten zu erhalten, wird ein Hindernis am Rande des Sichtfelds angenommen und ein Punkt künstlich erzeugt.
Aus dieser Menge an Punkten kann anschließend die Merkmalsberechnung wie in @sec:merkmale beschrieben durchgeführt werden.

Die Ermittlung der Isovisten-Eckpunkte aus Lidar-Scans erfolgt analog.
Dabei ist zu beachten, dass der rohe Lidar-Scan keinerlei Informationen zu den Koordinaten der gemessenen Punkte enthält.
Es ist lediglich der Winkel $theta$ (ausgehend vom 0°-Punkt des Lidar-Sensors), die gemessene Distanz zum Hindernispunkt sowie die Validität der Messung (z. B. da kein Hindernis getroffen wurde) gegeben.
Die Messungen können als Polarkoordinaten betrachtet und mit dieser Formel in kartesische Koordinaten umgerechnet werden:
$
  x_i &= sin(theta) * "Distanz" \
  y_i &= cos(theta) * "Distanz"
$
Die so ermittelten Punkte lassen sich anschließend für die Merkmalsberechnung nutzen, wobei bei allen invaliden Messungen angenommen wird, dass das Hindernis direkt nach Ende der Sichtweite existiert.
Ein simulierter Lidar-Scan ist in @fig:lidar-scan zu sehen.
Der daraus berechnete Isovist kann @fig:lidar-isovist entnommen werden.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/lidar.png", width: 90%),
      caption: [Roher Lidar-Scan des Roboters],
    )<fig:lidar-scan>],
  [#figure(
      image("assets/lidar-isovist.png", width: 90%),
      caption: [Aus Lidar-Scan berechneter Isovist],
    )<fig:lidar-isovist>],
)

= Ergebnisse und Diskussion

Zur Validierung der vorgestellten Lösungsstrategie des KRP wird eine Evaluation durchgeführt.
Dabei wird überprüft, ob es nach Veränderung der Position des Roboters ohne dessen Wissen darüber möglich ist, die Position anhand der berechneten Isovisten-Merkmale zu ermitteln.
Wird der in @fig:lidar-isovist gezeigte Isovist mit dessen Merkmalsvektor zur Lokalisation verwendet, so ergibt dies die in @fig:isovist-full gezeigte Positionsschätzung.
Betrachtet man diese genauer, so ergibt sich ein minimaler Fehler, da die Position des Lidar-Sensors nicht exakt mit der des ähnlichsten Isovisten übereinstimmt.
Eine solche Diskrepanz ist jedoch nicht vermeidbar, da die Roboterposition nie exakt die diskret bestimmten Punkte des Grids treffen kann.
Der beschriebene Fehler kann @fig:isovist-closeup entnommen werden.
Die geschätzte Position ist als blaues Kreuz dargestellt, während die Abweichung zum Lidar-Sensor des Roboters als rote Linie gezeigt ist.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/isovist-full.png", width: 90%),
      caption: [Lokalisation anhand eines Isovisten],
    )<fig:isovist-full>],
  [#figure(
      image("assets/isovist-closeup.png", width: 90%),
      caption: [Fehler der Lokalisation],
    )<fig:isovist-closeup>],
)

Zur quantitativen Analyse der Genauigkeit der Lokalisierungsstrategie wird der Roboter an zehn zufälligen Positionen abgesetzt und anschließend die Position ermittelt.
Für jede Messung wird der Abstand zur tatsächlichen Position $epsilon$ gemessen, um einen mittleren Wert für den durch die Lokalisation erzeugten Fehler $overline(epsilon)$ zu erhalten.
Dieser gilt als Perfomance-Indikator für die Qualität der Lokalisierung, wobei ein geringer Wert besser ist, das Optimum von $epsilon = 0$ praktisch jedoch nie erreicht werden kann.

In Experiment 1 sind dabei nur die Merkmale _Fläche_, _Umfang_, _Kompaktheit_ und _Drift_ enthalten.
Experiment 2 erweitert diese Menge um radialen Längen.
In Experiment 3 werden ebenfalls die radialen Momente betrachtet.
Die Ergebnisse können @tab:fehler entnommen werden.
Dabei konnte der geringste Fehler bei Verwendung aller Isovisten-Merkmale erzielt werden.

// TODO: Mehr samples generieren -- ggf. direkt in Carbot-Umgebung
#let samples = (
  (44.72, 14.14, 14.14),
  (12.37, 12.37, 78.06),
  (11.18, 11.18, 11.18),
  (5.01, 5.01, 5.01),
  (291.22, 352.06, 352.06),
  (6.08, 6.08, 6.08),
  (43.08, 413.81, 136.37),
  (440.12, 5.39, 5.39),
  (21.19, 21.19, 12.21),
  (79.16, 79.16, 12.08),
)
#let meanAt(i) = calc.round(samples.map(sample => sample.at(i)).sum() / samples.len(), digits: 2)
#figure(
  placement: auto,
  table(
    columns: (auto, auto, auto, auto),
    table.header(
      [*Sample \#*],
      [*Experiment 1 ($epsilon$)*],
      [*Experiment 2 ($epsilon$)*],
      [*Experiment 3 ($epsilon$)*],
    ),
    ..samples.enumerate().map(x => ([#(x.at(0) + 1)], ..x.at(1).map(v => [#calc.round(v, digits: 2)]))).flatten(),
    [*$overline(epsilon)$*], [*#meanAt(0)*], [*#meanAt(1)*], [*#meanAt(2)*],
  ),
  caption: [Distanzen zwischen tatsächlicher und geschätzter Position],
) <tab:fehler>

Hervorzuheben ist der bei Sample 5 auftretende hohe Fehlerwert.
Dieser ist vorrangig auf die hoch symmetrische Umgebung zurückzuführen.
Haben zwei Isovisten die gleiche Form, sind jedoch gespiegelt, so ist dies in keinem der verwendeten Merkmale repräsentiert.
Zur Behebung dessen kann die in @sec:merkmale beschriebene radiale Sequenz verwendet werden.
Dies führt jedoch zu einer erheblichen Erhöhung des Rechenaufwands, da jeder Merkmalsvektor die Längen aller Radiale enthalten muss.
Durch die Auflösung des verwendeten Lidar-Sensors ergeben sich somit 400 weitere Merkmalsdimensionen, die bei Positionsschätzung verglichen werden müssen.
Die Verwendung dieses Merkmals ist demnach nur dann einzusetzen, wenn die Arbeitsumgebung, in welcher der Roboter eingesetzt wird, dies erfordert.

= Fazit und Ausblick

Die vorliegende Arbeit hat erfolgreich gezeigt, dass durch die Verwendung von Isovisten und daraus berechneten Merkmalen eine effektive Lokalisierung in Indoor-Umgebungen möglich ist.
Dies erlaubt es, dem vorgestellten Kidnapped Robot Problem zu begegnen und nur mithilfe eines Lidar-Scans die Position des Roboters auf einer vorher angelegten Karte zu bestimmen.

Es konnte gezeigt werden, dass die ausgewählten Merkmale jeweils eine stetige Verbesserung der Genauigkeit der Positionsbestimmung erzielen, sodass im besten Fall alle Merkmale zur Bestimmung eines Isovisten herangezogen werden sollten.
Ist dies z. B. aufgrund eingeschränkter Rechenkapazitäten nicht möglich, so kann jedoch auch mit einem kleinen Set an Merkmalen eine Abschätzung der Position erreicht werden.
Zur Verbesserung dieser könnten mehrere Messungen an verschiedenen Positionen nacheinander durchgeführt werden, um eine genauere Schätzung zu erhalten.
Die Abwägung zwischen Rechen- und Zeitaufwand zur Erreichung einer ausreichenden Genauigkeit ist jedoch individuell für den jeweiligen Anwendungsfall zu treffen.

Die in dieser Arbeit betrachtete Umgebung bestand nur aus statischen Hindernisobjekten, welche sich sowohl während des Kartografierens als auch bei späterer Positionsbestimmung nicht verändert haben.
Eine Fortführung des gezeigten Ansatzes ist hinsichtlich der Robustheit gegenüber dynamischen Objekten in der Arbeitsumgebung zu untersuchen und ggf. anzupassen.

\ \ \
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
