#let title = "Kidnapped Robot Problem:\nIndoor-Lokalisierung mit Isovisten"

#let authors = (
  (name: "Tan Phat Nguyen", email: "nguyenta100556@th-nuernberg.de"),
  (name: "Nils Weber", email: "weberni76153@th-nuernberg.de"),
)

#set document(
  title: title.replace("\n", " "),
  author: authors.map(author => author.name).join(", "),
)

#set text(font: "New Computer Modern", lang: "de", size: 12pt)

#set page(
  paper: "a4",
  margin: (right: 2.5cm, left: 2.5cm, top: 2.5cm, bottom: 2cm),
  header: context if counter(page).get().at(0) > 1 { text(size: 10pt, title.replace("\n", " ")) },
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
    #link("mailto:"+author.email)
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

Die zentrale Forschungsfrage dieser Arbeit ist, in welchem Maße ein Ansatz basierend auf der Analyse von LiDAR-basierten Isovisten zur Lösung des "Kidnapped Robot Problems" in einer Indoor-Umgebung beitragen kann.

= Grundlagen und Stand der Technik

In diesem Kapitel wird das Kidnapped Robot Problem beschrieben sowie aktuelle Herangehensweisen an dieses erläutert, welche sich auf vorrangig auf die Fusion verschiedener Sensordaten fokussieren.
Die genaue Betrachtung von Isovisten ermöglicht es, eine alternative Lösungsstrategie zu skizzieren, welche diese als primäre Quelle zur Lokalisierung nutzt.

== Das Kidnapped Robot Problem

Das Kidnapped Robot Problem (KRP) in Innenräumen stellt eine spezielle Form des globalen Lokalisierungsproblems dar. Dabei muss der Roboter seine Position und Orientierung (Pose) ohne vorherige Kenntnis bestimmen. Dies ist eine wichtige Fähigkeit für autonome Roboter, besonders in Umgebungen ohne verlässliche GPS-Signale. Aktuelle Verfahren im Stand der Technik konzentrieren sich auf robuste und genaue Lokalisierungsmethoden, die solche drastischen Zustandsänderungen verarbeiten und eine schnelle Wiederherstellung der Lokalisierung ermöglichen können.

Im Rahmen des Stands der Technik zur Bewältigung des KRP ist die LiDAR-basierte Lokalisierung, unter Verwendung von Algorithmen wie Monte Carlo Localization (MCL), ein verbreiteter Ansatz. MCL nutzt einen Partikelfilter, um eine Wahrscheinlichkeitsverteilung über mögliche Posen zu führen und diese basierend auf der Übereinstimmung von Sensordaten mit einer vorhandenen Karte zu aktualisieren @thrun_ProbabilisticRoboticsIntelligent_2005. Obwohl effektiv, kann die Leistung von MCL in Umgebungen mit sich wiederholenden Strukturen oder wenigen Merkmalen nachlassen. Dies macht sie anfällig für das Kidnapped Robot Problem, wenn die anfängliche Posenschätzung weit von der tatsächlichen Position abweicht.

Als Alternative oder Ergänzung bei der Adressierung des KRP bieten sich Computer-Vision-Techniken an. Visuelle Platzerkennung, bei der aktuelle Kamerabilder mit einer Datenbank bekannter Orte verglichen werden, kann eine globale Posenschätzung zur Unterstützung der Relokalisierung nach einem Entführungsereignis liefern @cummins_ProbabilisticAppearanceBased_2007a. Die Kombination von visuellen und probabilistischen Lokalisierungsmethoden kann die Robustheit erhöhen, insbesondere in visuell komplexen Umgebungen.

Eine weitere Strategie zur Bewältigung des KRP ist die Kombination probabilistischer Lokalisierungsverfahren mit drahtlosen Sensordaten (wie von IMUs, funkbasierten Systemen, Bluetooth oder WLAN) @obeidat_ReviewIndoorLocalization_2021. Dieser Ansatz erhöht die Genauigkeit und liefert zusätzliche Lokalisierungsinformationen, was ebenfalls zur Robustheit bei plötzlichen Positionsänderungen beitragen kann.

Die Bewältigung des Kidnapped Robot Problems stellt somit eine zentrale Anforderung an robuste Indoor-Lokalisierungssysteme dar. Aktuelle Forschung konzentriert sich dabei auf die Weiterentwicklung und Kombination verschiedener sensorischer Ansätze zur Verbesserung der Leistungsfähigkeit in solchen Szenarien.

== Isovisten

Isovisten werden formal definiert als "the set of all points visible from a given vantage point in space and with respect to the environment" @benedikt_takeholdspace_1979. Sie können auf verschiedene Weisen dargestellt werden, darunter Sichtbarkeitsgraphen oder Polyeder für 3D-Repräsentationen und Polygone im zweidimensionalen Bereich. Diese Darstellungen dienen als ein eindeutiger räumlicher "Fingerabdruck" für einen gegebenen Standort.

Die Forschung untersucht die Nutzung von Isovisten-Merkmalen für die Indoor-Lokalisierung. Dies beinhaltet die Entwicklung von Verfahren zur Generierung von 2D- und 3D-Isovisten aus Punktwolken, die von Sensoren wie LiDAR erfasst werden. Darüber hinaus wird untersucht, wie Isovistenmaße die räumliche Struktur von Gebäuden erfassen und wie diese Merkmale zur Platzerkennung eingesetzt werden können, oft unter Nutzung von Methoden des maschinellen Lernens @sedlmeier_Learningindoorspace_2018.

Allerdings teilen Isovisten Herausforderungen mit anderen Lokalisierungsverfahren. Dazu gehören die Empfindlichkeit gegenüber dynamischen Umweltveränderungen (wie der Anwesenheit von Personen oder beweglichen Objekte), das Risiko von Mehrdeutigkeiten in Umgebungen mit sich wiederholenden architektonischen Merkmalen sowie der rechnerische Aufwand @thrun_ProbabilisticRoboticsIntelligent_2005. Isovisten sind von diesen Schwierigkeiten betroffen.

Infolgedessen werden Isovisten aufgrund dieser Einschränkungen und ihres aktuellen Entwicklungsstands eher als komplementäre Informationen in breitere Lokalisierungs- oder Platzerkennungsframeworks integriert, anstatt als alleiniger oder primärer Lokalisierungsmechanismus zur Bewältigung von Entführungsereignissen zu dienen.

= Methodik

In diesem Kapitel wird die entwickelte Methodik zur Indoor-Lokalisierung unter Verwendung von Lidar-basierten Isovist-Merkmalen beschrieben. Ein spezifischer Fokus liegt dabei auf der Bewältigung des Kidnapped Robot Problems. Die Experimente werden in einem Simulator durchgeführt, welcher den Roboter, die Umgebung und den Lidar-Sensor umfasst.

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

Durch die immer in gleichen Abständen platzierten Punkte eines ortogonalen Gitters ist es möglich, dass diese häufig zu nahe bzw. innerhalb von Hindernissen generiert werden (@fig:grid_ortho_zoom). Sie sind somit nicht zur Berechnung eines Isovisten verwendbar. Im eingeschränkten zufälligen Gitter kann dies vermieden werden, da die Gitterpunkte nicht an ein fest definiertes Raster gebunden sind (@fig:grid_random_zoom).

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

Die Wahl der Gridstruktur und die Einstellung ihrer spezifischen Parameter können somit variiert werden, um eine angemessene Abdeckung der Umgebung zu gewährleisten, die rechnerische Last zu steuern und die Robustheit der Lokalisierung zu optimieren.

== LiDAR-Scans und Merkmalsextraktion <sec:merkmale>

Nachdem das Grid über der Umgebungskarte generiert wurde und somit die diskreten Lokalisierungspunkte festgelegt sind, wird für jeden dieser Grid-Knoten eine Merkmalsbeschreibung basierend auf simulierten Lidar-Scans erstellt. Hierzu wird für jeden einzelnen Grid-Knoten ein Lidar-Scan von seiner spezifischen Position aus simuliert. Diese Simulation erzeugt eine Punktwolke, welche die sichtbaren Umgebungsmerkmale aus der Perspektive des jeweiligen Grid-Knotens darstellt.
Aus dieser simulierten Punktwolke werden anschließend verschiedene Isovist-Merkmale extrahiert. Diese Merkmale quantifizieren unterschiedliche Aspekte der sichtbaren Fläche und dienen als räumlicher "Fingerabdruck" für jeden Grid-Knoten. Es werden die folgenden Isovist-Merkmale verwendet:

*Fläche:* Dieses Merkmal repräsentiert die gesamte sichtbare Fläche vom jeweiligen Standpunkt aus. Die Fläche des Isovist-Polygons wird unter Verwendung des Shoelace-Algorithmus berechnet:

$ "Fläche" = 1 / 2 abs(sum^N_(i=1) x_i (y_i+1 - y_y-1)) $

*Umfang:* Dieses Merkmal beschreibt die Gesamtlänge der Begrenzungslinie des Isovisten bzw. Der Umfang des Isovisten-Polygons ist die Summe der Längen seiner Begrenzungssegmente:
$ "Umfang" = sum^N_(i=1) sqrt((x_(i+1)-x_i)^2 + (y_(i+1)-y_i)^2) $

*Kompaktheit:* Dieses Merkmal gibt ein Maß dafür an, wie "kreisförmig" die sichtbare Fläche ist. Die Kompaktheit ist ein dimensionsloses Maß, definiert als:
$ "Kompaktheit" = (4 pi dot "Fläche") / "Umfang"^2 $

*Drift:* Dieses Merkmal repräsentiert die Distanz vom Standpunkt $(v_x, v_y)$ zum Schwerpunkt $(c_x, c_y)$ des Isovist-Polygons:
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

*Radiale Momente (Mittelwert, Varianz, Schiefe):* Die radialen Momente quantifizieren Eigenschaften der sichtbaren Fläche basierend auf der Verteilung des radialen Abstands vom Standpunkt zur Isovist-Begrenzung. Für einen polygonalen Isovisten werden die rohen radialen Momente $M_1, M_2, M_3$ wie folgt berechnet:

$
M_("avg") &= a_1 \
M_("var") &= a_2 - M_("avg")^2 \
M_("skew") &= a_3 - 3 M_("avg") a_2 + 2 M_("avg")^3
$

wobei die Terme $a_1, a_2, a_3$ sich auf die Summe über alle Begrenzungssegmente $i$ des Isovist-Polygons beziehen und wie folgt definiert sind:

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

Die geometrischen Parameter für Seitenlängen ($a_i, b_i, c_i$) und Winkel ($alpha_i, beta_i, gamma_i$) beziehen sich auf das Dreieck, das durch den Standpunkt und das $i$-te Begrenzungssegment gebildet wird.

// TODO: Grafik zur Visualisierung dieses Dreiecks erstellen

Diese extrahierten Isovisten-Merkmale werden als Vektor zusammen mit der Position des jeweiligen Knotens gespeichert. Dies bildet den Datensatz bekannter Merkmale, der für die Relokalisierung nach Kidnapping des Roboters benötigt wird.

== Relokalisierung

Die Effizienz und Robustheit dieses Relokalisierungsprozesses hängen von der Dichte des Kartengrids, der Diskriminierungsfähigkeit der gewählten Isovisten-Merkmale und der Effizienz des Vergleichsalgorithmus ab. Nachdem die Isovisten-Merkmale sowohl für die generierten Grid-Knoten (basierend auf Simulationen) als auch für den aktuellen Lidar-Scan des Roboters extrahiert wurden (@fig:isovists_features), besteht der nächste Schritt darin, die Ähnlichkeit zwischen dem aktuellen Merkmalsvektor des Roboters und den gespeicherten Merkmalsvektoren jedes Grid-Knotens zu bestimmen.

Diese Ähnlichkeitsbestimmung erfolgt mithilfe einer geeigneten Distanzfunktion. Durch die Berechnung der Distanz zwischen den Merkmalsvektoren kann quantifiziert werden, wie ähnlich die aktuelle Sicht des Roboters der simulierten Sicht an jedem einzelnen Grid-Knoten ist. Für diesen Zweck können verschiedene Distanzfunktionen eingesetzt werden, darunter die euklidische Distanz, die Kosinus-Ähnlichkeit und die Manhattan-Distanz. Die Wahl der Distanzfunktion kann die Interpretation von Ähnlichkeit im Merkmalsraum beeinflussen und sollte auf die Eigenschaften der verwendeten Isovist-Merkmale abgestimmt sein.

Der Grid-Knoten, dessen Merkmalsvektor die geringste Distanz (oder höchste Ähnlichkeit) zum aktuellen Merkmalsvektor des Roboters aufweist, wird als die wahrscheinlichste Position des Roboters angenommen. Der  Die Position des Roboters wird somit auf den Ort dieses am besten passenden Grid-Knotens im Kartengrid geschätzt.

#figure(
  image("assets/features.png", width: 100%),
  caption: "Karte mit Isovisten-Merkmalen",
)<fig:isovists_features>

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
                LineComment(Assign[$Q$][$Q union {"c.north()", "c.east()", "c.south()", "c.west()"}$], [Betrachte alle Nachbarn])
              }
            )
          },
        )
        Return[$R$]
      },
    )
  }
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
Aus dieser Menge an Punkten kann anschließend die Merksmalsberechnung wie in @sec:merkmale beschrieben durchgeführt werden.

Die Ermittlung der Isovisten-Eckpunkte aus Lidar-Scans erfolgt analog.
Dabei ist zu beachten, dass der rohe Lidar-Scan keinerlei Informationen zu den Koordinaten der gemessenen Punkte enthält.
Es ist lediglich der Winkel $theta$ (ausgehend vom 0°-Punkt des Lidar-Sensors), die gemessene Distanz zum Hindernispunkt sowie die Validität der Messung (z. B. da kein Hindernis getroffen wurde) gegeben.
Die Messungen können als Polarkoordinaten betrachtet und mit dieser Formel in kartesische Koordinaten umgerechnet werden:
$
  x_i &= sin(theta) * "Distanz" \
  y_i &= cos(theta) * "Distanz"
$
Die so ermittelten Punkte lassen sich anschließend für die Merksmalsberechnung nutzen, wobei bei allen invaliden Messungen angenommen wird, dass das Hindernis direkt nach Ende der Sichtweite existiert.
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

= Ergebnisse

Zur Validierung der vorgestellten Lösungsstrategie des KRP wird eine Evaluation durchgeführt.
Dabei wird überprüft, ob es nach Veränderung der Position des Roboters ohne dessen Wissen darüber möglich ist, die Position anhand der berechneten Isovisten-Merkmale zu ermitteln.

= Diskussion

= Fazit und Ausblick

#pagebreak(weak: true)
#bibliography("/refs.bib", style: "ieee", title: "Literaturverzeichnis")
#pagebreak(weak: true)
