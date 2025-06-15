#let title = "Kidnapped Robot Problem:\nIndoor-Lokalisierung mit Isovisten"

#let authors = (
  (name: "Tan Phat Nguyen", email: "nguyenta100556@th-nuernberg.de"),
  (name: "Nils Weber", email: "weberni76153@th-nuernberg.de"),
)

#set document(
  title: title.replace("\n", " "),
  author: authors.map(author => author.name).join(", "),
  description: "TODO",
)

#set text(font: "New Computer Modern", lang: "de", size: 12pt)

#set page(
  paper: "a4",
  margin: (right: 2.5cm, left: 2.5cm, top: 2.5cm, bottom: 2cm),
  header: context if counter(page).get().at(0) > 1 {
    text(size: 10pt, title.replace("\n", " "))
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

Mobile Roboter benötigen genaue Standortdaten für autonome Bewegung. Die Selbstlokalisierung ist grundlegend für Umgebungsinteraktionen. Eine präzise Positionsbestimmung auf einer Karte ist unerlässlich; ohne sie sind Aufgaben erschwert oder unmöglich. Autonome Reinigung, Güterzustellung und Führungsaufgaben erfordern durchgängig genaue Selbstverortung. Außenlokalisierung ist durch "Global Navigation Satellite System" wie GPS etabliert. Innenraum-Lokalisierung bleibt eine große Herausforderung.

Forschung an Lokalisierungsalgorithmen führt zu komplexeren Szenarien. Das Kidnapped Robot Problem (KRP) ist ein solches Beispiel. Es beschreibt, wie ein Roboter an einen unbekannten Ort gelangt oder seine Position verliert. Eine erfolgreiche KRP-Lösung zeigt, dass ein Roboter sich nach einem Lokalisierungsfehler neu orientieren und weiterarbeiten kann. Das Problem betont die Notwendigkeit von robusten Lokalisierungsansätzen, die auch in ungewöhnlichen Situationen zuverlässig sind.

Diese Arbeit untersucht einen Ansatz zur Indoor-Lokalisierung, der auf die Lösung des Kidnapped Robot Problems abzielt. Der Schwerpunkt liegt auf der Anwendung von Isovisten in Kombination mit LiDAR-Sensorik. Isovisten definieren den von einem spezifischen Punkt aus sichtbaren Raum. Sie erfassen die Form und Struktur der direkten Umgebung, indem sie die für einen Beobachter einsehbaren Punkte bestimmen. Die Struktur des sichtbaren Raumes kann als typisch für einen Ort betrachtet werden. Dies ermöglicht potenziell die Wiedererkennung nach Positionswechseln des Roboters. Ein LiDAR-Sensor erfasst die nötige Umgebungsgeometrie für die Isovisten-Analyse.

Die Kernfrage dieser Arbeit ist, ob ein Ansatz basierend auf LiDAR-gestützten Isovisten das Kidnapped Robot Problem in Innenräumen lösen kann. Die Versuche erfolgen in einem Simulator. Dieser enthält Roboter, Umgebung und LiDAR-Sensoren. Für die Untersuchung des Kidnapped Robot Problems dürfen die LiDAR-Sensoren beliebig positioniert werden; die Umgebung ist statisch.

= Grundlagen und Stand der Technik

Dieses Kapitel beschreibt das Kidnapped Robot Problem. Es erläutert aktuelle Lösungsansätze, die auf der Fusion von Sensordaten basieren. Zusätzlich werden Isovisten als Lösungsstrategie sowie deren Einschränkungen vorgestellt.

== Das Kidnapped Robot Problem

Das Kidnapped Robot Problem (KRP) in Innenräumen ist eine spezielle Art des globalen Lokalisierungsproblems. Dabei muss der Roboter seine Position und Ausrichtung (Pose) ohne Vorwissen bestimmen @thrun_ProbabilisticRoboticsIntelligent_2005. Dies ist wichtig für autonome Roboter, besonders wo GPS-Signale fehlen. Neue Verfahren zielen auf robuste und genaue Lokalisierung ab, die starke Positionsänderungen verarbeiten und eine schnelle Wiederherstellung der Lokalisierung ermöglichen.

Im Bereich der KRP-Lösung ist die LiDAR-basierte Lokalisierung mit Monte Carlo Localization (MCL) ein häufig genutzter Ansatz. MCL nutzt einen Partikelfilter. Dieser verwaltet eine Wahrscheinlichkeitsverteilung möglicher Posen und aktualisiert sie basierend auf der Übereinstimmung von Sensordaten mit einer Karte @thrun_ProbabilisticRoboticsIntelligent_2005. Ein Vorteil von MCL ist die direkte Verarbeitung von Rohsensormessungen. Dies ist nicht auf eine einzige, genaue Position begrenzt. Daher ist es grundsätzlich zur Lösung globaler Lokalisierungsprobleme und des Kidnapped Robot Problems fähig @thrun_ProbabilisticRoboticsIntelligent_2005.

Die Wirkung von MCL kann in Umgebungen mit vielen gleichen Strukturen oder wenigen Merkmalen sinken. Dies macht MCL anfälliger für das Kidnapped Robot Problem, besonders bei großen Fehlern in der Startposition oder komplettem Verlust der Lokalisierung. Um das KRP mit MCL zu lösen, nutzt man spezielle Techniken. Eine häufige ist, dem Partikelsatz zufällige Partikel hinzuzufügen. Das macht den Algorithmus stabiler, indem es eine ständige Neuinitialisierung der Lokalisierung erlaubt, als wäre der Roboter unwahrscheinlich "entführt" worden @thrun_ProbabilisticRoboticsIntelligent_2005. Ein anderer Ansatz ist Mixture MCL, der eine robuste KRP-Lösung bietet. Hierbei werden Partikel an Orten platziert, die aufgrund der letzten Messung sinnvoll erscheinen. Das sorgt für mehr Stabilität im praktischen Einsatz @thrun_ProbabilisticRoboticsIntelligent_2005.

Computer-Vision-Techniken können das KRP ergänzen oder ersetzen. Visuelle Platzerkennung vergleicht aktuelle Kamerabilder mit einer Ortsdatenbank. Dies ermöglicht eine globale Positionsschätzung und hilft bei der erneuten Lokalisierung nach einem "Entführungsereignis" @cummins_ProbabilisticAppearanceBased_2007a. Die Kombination von visuellen und probabilistischen Lokalisierungsmethoden kann die Robustheit erhöhen, besonders in visuell schwierigen Umgebungen.

Eine weitere Strategie zur Lösung des KRP ist die Nutzung von probabilistischen Lokalisierungsverfahren zusammen mit drahtlosen Sensordaten. Beispiele hierfür sind IMUs, Funksysteme, Bluetooth oder WLAN @obeidat_ReviewIndoorLocalization_2021. Dieser Ansatz kann die Genauigkeit steigern und zusätzliche Lokalisierungsinformationen liefern. Dies kann die Robustheit bei plötzlichen Positionswechseln verbessern.

Das Kidnapped Robot Problem zu lösen ist zentral für robuste Indoor-Lokalisierungssysteme. Die Forschung arbeitet daran, verschiedene Sensoransätze zu verbessern und zu verbinden. Ziel ist es, die Leistung in solchen Situationen zu erhöhen.

== Isovisten

#figure(
  image("assets/isovist.png", width: 80%),
  caption: "Visueller Bereich (Isovisten) von einem Standpunkt aus in einer Umgebung.",
) <fig:isovist>

Isovisten werden formal als "the set of all points visible from a given vantage point in space and with respect to the environment" definiert @benedikt_takeholdspace_1979. Wie in @fig:isovist gezeigt, bildet sich von einem Standpunkt aus die sichtbare Fläche. Nicht sichtbare Bereiche werden durch Wände begrenzt. Isovisten können unterschiedlich dargestellt werden, zum Beispiel als Sichtbarkeitsgraphen oder Polyeder für 3D-Darstellungen und Polygone im zweidimensionalen Bereich. Diese Darstellungen dienen als eindeutiger räumlicher "Fingerabdruck" für einen bestimmten Standort.

Die Forschung untersucht die Verwendung von Isovisten-Merkmalen zur Indoor-Lokalisierung. Hierzu gehören die Entwicklung von Methoden zur Erzeugung von 2D- und 3D-Isovisten aus LiDAR-Punktwolken. Zudem wird analysiert, wie Isovistenmaße die räumliche Struktur von Gebäuden erfassen und wie diese Merkmale, oft mittels maschineller Lernmethoden, zur Platzerkennung genutzt werden können @sedlmeier_Learningindoorspace_2018.

Isovisten haben ähnliche Probleme wie andere Lokalisierungsverfahren. Dazu gehören: Empfindlichkeit gegenüber dynamischen Änderungen (z.B. Personen, bewegliche Objekte), die Gefahr von Mehrdeutigkeiten in Umgebungen mit gleichen Baumerkmalen und der Rechenaufwand @thrun_ProbabilisticRoboticsIntelligent_2005. Isovisten sind von diesen Problemen auch betroffen.

Aufgrund dieser Einschränkungen und ihres derzeitigen Entwicklungsstands werden Isovisten eher als ergänzende Informationen in umfassende Lokalisierungs- oder Platzerkennungsframeworks integriert. Sie dienen nicht als primärer oder alleiniger Lokalisierungsmechanismus zur Bewältigung von Entführungsereignissen.

= Methodik zur Lösung des Kidnapped Robot Problems mittels Isovisten

Dieses Kapitel beschreibt die entwickelte Methodik zur Lösung des Kidnapped Robot Problems mittels LiDAR-basierter Isovisten-Merkmale für die Indoor-Lokalisierung. Die Experimente finden in einem Simulator statt, der den Roboter, die Umgebung und die LiDAR-Sensoren umfasst. Zur Untersuchung des Kidnapped Robot Problems können die LiDAR-Sensoren an beliebigen Positionen platziert werden; die Umgebung ist statisch.

== Kartengrid

Die Grundlage des Lokalisierungsansatzes bildet ein Grid, das auf der Umgebungskarte erstellt wird. Es stellt diskrete Lokalisierungspunkte innerhalb des Arbeitsbereichs des Roboters dar. Für diese Arbeit wird die Karte des Sonsbeek Pavilions von Aldo van Eyck aus dem Jahr 1966 genutzt @fabrizi_SonsbeekPavilionArnhem_2013. Diese Karte zeichnet sich durch ihre symmetrische Struktur und verschiedene kreisförmige Linien aus. Die Symmetrie und die komplexen geometrischen Formen wurden ausgewählt, um die Komplexität bei der Lösung des Kidnapped Robot Problems zu erhöhen. Für diesen Ansatz stehen zwei Hauptvarianten von Grids zur Verfügung.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho.png", width: 90%),
      caption: "Orthogonales Grid.",
    )<fig:grid_ortho>],
  [#figure(
      image("assets/grid_random.png", width: 90%),
      caption: "Eingeschränktes Zufalls-Grid.",
    )<fig:grid_random>],
)

Die erste Variante ist ein orthogonales Grid (kartesisches Grid), das üblicherweise für Isovisten-Analysen verwendet wird. Bei dieser Gridstruktur sind zwei Liniensätze senkrecht zueinander angeordnet (@fig:grid_ortho). Dies ermöglicht eine gleichmäßige Abdeckung. Jedoch sind die Nachteile des orthogonalen Grids bezüglich Ausrichtung zur Gebäudestruktur, Approximation gekrümmter Flächen und Umgang mit schmalen Öffnungen bekannt @conroy_dalton_isovist_2022. Der Abstand zwischen den Grid-Linien ist einstellbar, was die Dichte der Lokalisierungspunkte beeinflusst.

Als zweite Variante kann eine eingeschränkte zufällige Verteilung der Grid-Knoten verwendet werden. Dies orientiert sich an Konzepten wie der Restricted Randomised Visibility Graph Analysis (R-VGA). Diese Methode strebt eine robustere Analyse an, die weniger von der spezifischen Grid-Platzierung abhängt @conroy_dalton_isovist_2022. Die Lokalisierungspunkte werden hierbei nicht in einem starren Gridmuster platziert, sondern nach einem Verfahren, das eine gleichmäßigere Verteilung sicherstellt (@fig:grid_random). Bei der eingeschränkten zufälligen Verteilung kann die Gesamtanzahl der Grid-Knoten festgelegt werden, wodurch die Dichte der Lokalisierungspunkte kontrolliert wird.

#grid(
  columns: 2,
  column-gutter: 1em,
  [#figure(
      image("assets/grid_ortho_zoom.png", width: 70%),
      caption: "Orthogonales Grid: Punkte können sich in Hindernissen oder zu nah an diesen befinden.",
    )<fig:grid_ortho_zoom>],
  [#figure(
      image("assets/grid_random_zoom.png", width: 70%),
      caption: "Eingeschränktes Zufalls-Grid: Die Pfeile kennzeichnen Punkte, die im orthogonalen Grid nicht generiert würden.",
    )<fig:grid_random_zoom>],
)

Im orthogonalen Grid können durch die gleichmäßigen Abstände Punkte oft zu nah an oder in Hindernissen liegen (@fig:grid_ortho_zoom). Solche Punkte sind für die Isovistenberechnung unbrauchbar. Im eingeschränkten zufälligen Grid lässt sich dies vermeiden, da die Gridpunkte keinem festen Raster folgen. @fig:grid_random_zoom zeigt beispielhaft zwei Punkte, die im orthogonalen Grid nicht erzeugt, aber im eingeschränkten zufälligen Grid verfügbar sind.

Die Wahl der Gridstruktur und deren Parameter kann angepasst werden. Ziel ist, eine ausreichende Abdeckung der Umgebung, eine kontrollierte Rechenlast und eine optimierte Lokalisierungsrobustheit zu erreichen.

== LiDAR-Scans und Merkmalsextraktion <sec:merkmale>

Nachdem das Grid über der Umgebungskarte erstellt und die diskreten Lokalisierungspunkte festgelegt wurden, wird für jeden Grid-Knoten eine Merkmalsbeschreibung basierend auf simulierten LiDAR-Scans erstellt. Dazu wird für jeden einzelnen Grid-Knoten ein LiDAR-Scan von seiner spezifischen Position aus simuliert. Diese Simulation erzeugt eine Punktwolke, die die sichtbaren Umgebungsmerkmale aus der Perspektive des jeweiligen Grid-Knotens darstellt.

#figure(
  image("assets/features.png", width: 90%),
  caption: "Beispiel von Isovisten-Merkmalen auf einer Umgebungskarte.",
)<fig:isovists_features>

Aus den simulierten LiDAR-Scans jedes Grid-Knotens werden anschließend verschiedene Isovisten-Merkmale extrahiert. Diese Merkmale quantifizieren unterschiedliche Aspekte der jeweiligen sichtbaren Fläche. Sie dienen als räumlicher "Fingerabdruck" für den jeweiligen Grid-Knoten, wie in @fig:isovists_features beispielhaft dargestellt. Folgende Isovisten-Merkmale werden verwendet:

*Fläche:* Dieses Merkmal stellt die gesamte vom jeweiligen Standpunkt aus sichtbare Fläche dar. Die Fläche des Isovisten-Polygons wird mittels des Shoelace-Algorithmus berechnet:
$ "Fläche" = 1 / 2 abs(sum^N_(i=1) x_i (y_i+1 - y_y-1)) $

*Umfang:* Dieses Merkmal beschreibt die Gesamtlänge der Begrenzungslinie des Isovisten. Der Umfang des Isovisten-Polygons ist die Summe der Längen seiner Begrenzungssegmente:
$ "Umfang" = sum^N_(i=1) sqrt((x_(i+1)-x_i)^2 + (y_(i+1)-y_i)^2) $

*Kompaktheit:* Dieses Merkmal quantifiziert die "Kreisförmigkeit" der sichtbaren Fläche. Die Kompaktheit ist ein dimensionsloses Maß, definiert als:
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

wobei sich die Terme $a_1, a_2, a_3$ auf die Summe über alle Begrenzungssegmente $i$ des Isovisten-Polygons beziehen und wie folgt definiert sind:

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

Die geometrischen Parameter für Seitenlängen ($a_i, b_i, c_i$) und Winkel ($alpha_i, beta_i, gamma_i$) beziehen sich auf das Segment-Dreieck. Dieses Dreieck wird durch den Standpunkt und die zwei benachbarten Eckpunkte des Isovisten-Polygons gebildet (siehe @fig:isovist_triangle).

Diese extrahierten Isovisten-Merkmale werden als Vektor mit der Position des jeweiligen Knotens gespeichert. Dies bildet den Datensatz bekannter Merkmale, der für die Relokalisierung nach einem Roboter-Kidnapping erforderlich ist.

== Relokalisierung

Die Effizienz und Robustheit der Relokalisierung hängen von der Dichte des Kartengrids, der Unterscheidungsfähigkeit der Isovisten-Merkmale und der Effizienz des Vergleichsalgorithmus ab. Nach der Extraktion der Isovisten-Merkmale für die generierten Grid-Knoten (basierend auf Simulationen) und den aktuellen LiDAR-Scan des Roboters wird die Ähnlichkeit zwischen dem aktuellen Merkmalsvektor des Roboters und den gespeicherten Merkmalsvektoren jedes Grid-Knotens bestimmt.

Die Ähnlichkeitsbestimmung erfolgt mittels passender Methoden. Zuerst werden die Merkmalswerte der Isovisten-Vektoren normalisiert. Dies geschieht meist in einem Bereich von 0 bis 1, um zu verhindern, dass einzelne Merkmale durch ihre Wertebereiche den Vergleich dominieren. Für die normalisierten Merkmalsvektoren wird die Ähnlichkeit der aktuellen Sicht des Roboters mit der simulierten Sicht an jedem Grid-Knoten durch Distanzberechnung ermittelt. Hierfür können verschiedene Distanzfunktionen wie die euklidische Distanz, die Kosinus-Ähnlichkeit und die Manhattan-Distanz genutzt werden. Die Wahl der Ähnlichkeits- oder Distanzfunktion sollte zu den Eigenschaften der verwendeten Isovisten-Merkmale passen.

Die radiale Sequenz ist ein Array und lässt sich nicht direkt mit den erwähnten Distanzfunktionen vergleichen. Eine Normalisierung ist hier nicht nötig. Für dieses Merkmal wird Dynamic Time Warping (DTW) eingesetzt, um die Ähnlichkeit zweier Sequenzen zu bestimmen. Bei DTW sind Einstellungen verfügbar, die 25 %, 50 %, 75 % oder 100 % der Sequenzlänge berücksichtigen. Dies kann die Leistung der Rekolokalisierung beeinflussen.

Der Grid-Knoten mit der geringsten Distanz (oder höchsten Ähnlichkeit) zum aktuellen Merkmalsvektor des Roboters wird als wahrscheinlichste Position angenommen. Die Roboterposition wird somit auf den Ort dieses am besten passenden Grid-Knotens im Kartengrid geschätzt.

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
