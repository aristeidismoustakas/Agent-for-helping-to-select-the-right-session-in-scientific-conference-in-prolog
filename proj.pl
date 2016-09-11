/* Moustakas Aristeidis  AEM: 2380 */

/*To κατηγόρημα query παίρνει σαν όρισμα μια λίστα από keywords, καλεί το κατηγόρημα preparation ώστε να την ετοιμάσει με το κατάλληλο format με τα βάρη, κάλει την startComputeScores ώστε να υπολογίσει το score κάθε session με βάση την λίστα με τα keywords, καλεί την qsort για να ταξινομήσει την λίστα με τα scores και τέλος καλέι την printScores ώστε να εκτυπώσει την λίστα με τον κατάλληλο τρόπο.*/
query(L):-
	preparation(L,FL),
	startComputeScores(FL,ScoreList),
	qsort(ScoreList,SortedScoreList),
	printScores(SortedScoreList),!.


/*To κατηγόρημα preparation καλεί την prep δίνοντας της ως 1ο όρισμα μια λίστα με τα keywordwors έτσι όπως τα έδωσε ο χρήστης, (2ο όρισμα μια λίστα που  θα έχει μέσα τα τελικά αποτελέσματα και μια κενή λίστα που θα χρησιμοποιηθεί ως temp λίστα για ενδιάμεσα αποτελέσματα.    */


preparation([X|S],Res):- prep([X|S],Res,[]).


/*To κατηγόρημα prep παίρνει ως πρώτο όρισμα μια λίστα με τα keywords , μια λίστα TempRes που θα καρατάει ενδιάμεσα αποτελέσματα μέχρι εκείνη την στιγμή και την λίστα Res που θα έχει την τελική λίστα με τα keywords στο κατάλληλο format και με τα κατάλληλα βάρη  .Aν το keyword που είναι εκείνη την ώρα η κεφαλή της λίστας με τα keywords έχει κάποιο βάρος ενοποιείται με το prep([X-W|S],Res,TempRes) αλλιώς αν δεν έχει βάρος με το prep([X|S],Res,TempRes) και θεωρείται ότι έχει βάρος 1. Με οποιοδήποτε από τα 2 κατηγορήματα και να ενοποιηθεί καλείται η tokenize_atom ώστε να μετατρέψει το keywords σε μια λιστα από λέξεις και στην στην συνέχεια καλούμε την length για αυτήν την λίστα από τις λέξεις (παίρνοντας το length καταλαβαίνουμε και αν το keyword είναι φράση ή λέξη). Στην συνέχεια καλείται το κατηγόρημα addInFinalList που παίρνει σαν όρισμα την λέξη-φράση , την λίστα που δημιούργησε η tokenize_atom, το length της λίστας , το βάρος της λέξης φράσης και 2 λίστες , την TempRes που θα καρατάει ενδιάμεσα αποτελέσματα και την ΝRes που θα έχει την τελική λίστα που θα έχει μέσα τα keywords στο κατάλληλο format και με τα κατάλληλα βάρη. Τέλος καλείται το prep αναδρομικά για την ουρά της λίστας. Αυτό συνεχίζεται μέχρι να  να αδειάσει η λίστα με τα keywords δηλαδή να γίνει ενοποίηση με το prep([],Res,Res) όπου και η προσωρινή μέχρι τότε λίστα (ΤempRes) αντιγράφεται στο τελική λίστα (Res).
*/

prep([],Res,Res):-!.
prep([X-W|S],Res,TempRes):-
	tokenize_atom(X,L),
	length(L,Len),
	addInFinalList(X,L,Len,W,TempRes,NRes),
	!,prep(S,Res,NRes).
prep([X|S],Res,TempRes):-
	tokenize_atom(X,L),
	length(L,Len),
	addInFinalList(X,L,Len,1,TempRes,NRes),
	prep(S,Res,NRes).


/*To κατηγόρημα addInFinalList παίρνει σαν ορίσματα μια λέξη-φράση (Χ), μια λίστα από τις λέξεις ([S] ή List) της λέξης-φράσης, το μήκος αυτής της λίστας, το βάρος της λέξης-φράσης, μια λίστα Current που περιέχει ήδη κάποιες έτοιμες λέξεις κλειδιά από προηγούμενη επεξεργασία και την λίστα Res που στο θα είναι η Current έχοντας κάνει append κάποιες νέες λέξεις κλειδιά με τα βάρη τους. Αν το keyword είναι μόνο μία λέξη και όχι ολόκληρη φράση γίνεται ενοποίηση με έναν από τους 2 πρώτους κανόνες ανάλογα με το αν είχε μαζί και βάρος ή όχι καιι γίνεται append ( αφού έχει μετατραπέι στην μορφή keyword-weight) με την Current λίστα και το αποτέλεσμα αποθηκέυεται στην Res λίστα. Αν το keyword είναι φράση γίνεται ενοποίηση με τον 3ο κανόνα όπου εκεί καλείται το κατηγόρημα phrasePrep το οποίο πέρνει την λίστα με τις λέξεις της φράσης και την Current λίστα  και επιστρέφει μια λίστα που περιέχει όλες τις λέξεις της φράσης ξεχωριστά και με τα κατάλληλα βάρη έχοντας την κάνει append με την Current λίστα .Τέλος σ αυτήν την λίστα που επέστρεψε η phrasePrep γίνεται append και ολόκληρη την φράση με το κατάλληλο βάρος της.	 */


addInFinalList(_X,[S],1,1,Current,Res):-
	Q=S-1,
	!,append(Current,[Q],Res).
addInFinalList(_X,[S],1,W,Current,Res):-
	Q=S-W,
	!,append(Current,[Q],Res).
addInFinalList(X,List,Len,W,Current,Res):-
	phrasePrep(List,Len,W,Current,TempRes),
	Q=X-W,
	append(TempRes,[Q],Res).



/*To κατηγόρημα phrasePrep πάρνει σαν όρισμα μια λίστα με τις λέξεις μια φράσης, το μήκος αυτής της λίστας , το βάρος αυτής της φράσης, την Current λίστα που περιέχει τα αποτελέσματα μέχρι εκείνη την στιγμή. Στην συνέχεια δημιουργέι ( αναδρομικά ) μια λίστα με τα keywords και τα κατάλληλα βάση και την κάνει append με την Current λίστα. Τέλος κάνει ενοποίησει αυτήν την λίστα που δημιούργησε με την μεταβλητη Res που θα περιέχει και το τελική λίστα που επιθυμούμε ( τερματική συνθήκη ).  */

phrasePrep([],_,_,Res,Res):-!.
phrasePrep([X|SubList],Len,W,Current,Res):-
	R is W/Len,
	Q=X-R,
	append(Current,[Q],TempRes),
	phrasePrep(SubList,Len,W,TempRes,Res).




/*To startComputeScores παίρνει σαν όρισμα την κατάλληλα προετοιμασμένη λίστα με τα keywords και επιστρέφει την τελική λίστα για το με τα scores για το κάθε session. Αυτό γίνεται χρησιμοποιώντας το κατηγόρημα findall το οποίο θα συλλέξει όλα τα scores που θα προκύψουν απο το backtracking λόγω το πολλών κατηγορημάτων session. To findall παίρνει σαν όρισμα το πεδίο που θα υπολογίζουμε και θα προσθέτουμε στην λίστα σε κάθε backtracking ( S ), το κατηγόρημα που θα χρησιμοποιήσουμε (computeScores(Keywords,S)) και την λίστα με που θα περιέχει τα τελικά scores (ScoreList).*/

startComputeScores(Keywords,ScoreList):-findall(S,computeScores(Keywords,S),ScoreList).


/*To κατηγόρημα computeScores παίρνει σαν ορίσμα μια λίστα με όλα τα keywords και υπολογίζει μια μεταβλητη S που θα περιέχει τον τίτλο και score κάποιου συγκεκριμένου session. Aρχικά γίνεται ταύτιση με τον τίτλο και την λίστα από τα topics κάποιου session (session(Title,Topics)), στην συνέχεια καλέιται το κατηγόρημα phraseScore (το οποίο υπολογίζει το score μιας φράσης) και υπολογίζει το score του τίτλου το οποίο στην συνέχεια πολλαπλασιάζεται  επι 2 και  έπειτα καλεί το κατηγόρημα  topicsScore το οποίο υπολογίζει το score όλων την υποθεμάτων αθροιστικά(και το max score που είχε κάποιο υποθέμα).Τέλος παίρνουμε το max ανάμεσα στο max των υποθεμάτων και το score του τίτλου και υπολογίζουμε το score για το συγκεκριμένο session (Tscore is TitleScoreX2+TopicsScore+1000*FScore). Tέλος ενοποιούμε στην μεταβλητή S με το Title-Tscore.*/


computeScores(Keywords,S):-
	session(Title,Topics),
	phraseScore(Keywords,Title,0,TitleScore),
	TitleScoreX2 is 2*TitleScore,
	topicsScore(Keywords,Topics,0,TopicsScore,0,Max),
	max(TitleScoreX2,Max,FScore),
	Tscore is TitleScoreX2+TopicsScore+1000*FScore,
	S=Title-Tscore.

/* Το κατηγόρημα topicsScore παίρνει μια λίστα από Κeywords και μια λίστα από topics κάποιου session και υπολογίζει( αναδρομικά ) το άθροισμα των scores που συγκεντρώνουν αυτά τα topics για τα συγκεκριμένα keywords. Επίσης κρατάει ένα max ώστε να ξέρουμε στο τέλος το μέγιστο score που συγκέντρωθηκε από κάποιο από τα topics.   */

topicsScore(_Keywords,[],Score,Score,Max,Max):-!.
topicsScore(Keywords,[T|Topics],Temp,Score,Tmax,Max):-
	phraseScore(Keywords,T,0,S),
	max(Tmax,S,TempMax),
	Tt is Temp + S,
	topicsScore(Keywords,Topics,Tt,Score,TempMax,Max).




/* Το κατηγόρημα max πάιρνει 2 τιμές X και Y επιστρέφει σε μια τρίτη μεταβλητή την μεγαλύτερη από αυτές.*/
max(X,Y,X) :- X>Y,!.
max(X,Y,Y) :- X=<Y.




/*To κατηγόρημα phraseScore υπολογίζει ( αναδρομικά )το score μιας φράσης με βάση μια συγκεκριμένη λίστα από keywords. Πιο συγκεκριμένα εάν υπάρχει το keyword (που βρίσκεται στην κεφαλη της λίστας των keywords) μέσα στην φράση τότε προσθέτουμε το βάρος του με μία μεταβλητή temp η οποία περίεχει το score που υπολογίστηκε μέχρι τώρα το οποία θα είναι το νέο temp. Αν δεν υπάρχει τότε καλείται ο 3ος κανόνας και δεν γίνεται κάτι, απλά γίνεται αναδρομική κλήση με το ίδιο temp. Τέλος υπάρχει ένας κανόνας τερματισμού μολίς ελεγχθουν όλα τα keywords και γίνεται αντιγραφή του προρωρινού score (temp) στο τελικό αποτέλεσμα (Score). */

phraseScore([],_,Score,Score):-!.
phraseScore([Key-Weight|SubList],Phrase,TempScore,Score):-
	sub_string(case_insensitive,Key,Phrase),
	T is Weight+TempScore,
	phraseScore(SubList,Phrase,T,Score),!.
phraseScore([_Key-_Weight|SubList],Phrase,TempScore,Score):-
	phraseScore(SubList,Phrase,TempScore,Score).









/*Το κατηγόρημα qsort (μαζί με το κατηγόρημα split, και τα 2 μαζί υλοποιούν την quicksort) δέχεται ως όρισμα μία λίστα την κάνει ταξινόμηση ως προς το Score και αν υπάρχει ισοβαθμία ως προς τον τίτλο και στην συνέχεια  επιστρέφει αυτήν την ταξινομημένη λίστα στην μεταβλητή Sorted. */

qsort([],[]):-!.
qsort([X|L],Sorted) :-
		split(X,L,Small,Big),
		qsort(Small,SortedSmall),
		qsort(Big,SortedBig),
		append(SortedSmall,[X|SortedBig],Sorted).

split(_X,[],[],[]).
split(Title1-Score1,[Title2-Score2|T],[Title2-Score2|Small],Big) :- Score1 < Score2,
		split(Title1-Score1,T,Small,Big).
split(Title1-Score1,[Title2-Score2|T],Small,[Title2-Score2|Big]) :- Score1 > Score2,
		split(Title1-Score1,T,Small,Big).
split(Title1-Score1,[Title2-Score2|T],[Title2-Score2|Small],Big) :- Score1 = Score2, Title1@<Title2,
		split(Title1-Score1,T,Small,Big).
split(Title1-Score1,[Title2-Score2|T],Small,[Title2-Score2|Big]) :- Score1 = Score2, Title1 @>= Title2,
		split(Title1-Score1,T,Small,Big).




/* Παίρνει σαν όρισμα μία λίστα με τα τελικά Scores και την εκτυπώνει στο κατάλληλο format.*/


printScores([]):-!.
printScores([Title-Score|SubList]):-
	write('Session:  '),write(Title),nl,write('        Relevance  =  '),write(Score),nl,
	printScores(SubList).




























% Facts about sessions, and respective topics

session('Rules; Semantic Technology; and Cross-Industry Standards',
	['XBRL - Extensible Business Reporting Language',
	 'MISMO - Mortgage Industry Standards Maintenance Org',
	 'FIXatdl - FIX Algorithmic Trading Definition Language',
	 'FpML - Financial products Markup Language',
	 'HL7 - Health Level 7',
	 'Acord - Association for Cooperative Operations Research and Development (Insurance Industry)',
	 'Rules for Governance; Risk; and Compliance (GRC); eg; rules for internal audit; SOX compliance; enterprise risk management (ERM); operational risk; etc',
	 'Rules and Corporate Actions']).
session('Rule Transformation and Extraction',
	['Transformation and extraction with rule standards; such as SBVR; RIF and OCL',
	 'Extraction of rules from code',
	 'Transformation and extraction in the context of frameworks such as KDM (Knowledge Discovery meta-model)',
	 'Extraction of rules from natural language',
	 'Transformation or rules from one dialect into another']).
session('Rules and Uncertainty',
	['Languages for the formalization of uncertainty rules',
	 'Probabilistic; fuzzy and other rule frameworks for reasoning with uncertain or incomplete information',
	 'Handling inconsistent or disparate rules using uncertainty',
	 'Uncertainty extensions of event processing rules; business rules; reactive rules; causal rules; derivation rules; association rules; or transformation rules']).
session('Rules and Norms',
	['Methodologies for modeling regulations using both ontologies and rules',
	 'Defeasibility and norms - modeling rule exceptions and priority relations among rules',
	 'The relationship between rules and legal argumentation schemes',
	 'Rule language requirements for the isomorphic modeling of legislation',
	 'Rule based inference mechanism for legal reasoning',
	 'E-contracting and automated negotiations with rule-based declarative strategies']).
session('Rules and Inferencing',
	['From rules to FOL to modal logics',
	 'Rule-based non-monotonic reasoning',
	 'Rule-based reasoning with modalities',
	 'Deontic rule-based reasoning',
	 'Temporal rule-based reasoning',
	 'Priorities handling in rule-based systems',
	 'Defeasible reasoning',
	 'Rule-based reasoning about context and its use in smart environments',
	 'Combination of rules and ontologies',
	 'Modularity']).
session('Rule-based Event Processing and Reaction Rules',
	['Reaction rule languages and engines (production rules; ECA rules; logic event action formalisms; vocabularies/ontologies)',
	 'State management approaches and frameworks',
	 'Concurrency control and scalability',
	 'Event and action definition; detection; consumption; termination; lifecycle management',
	 'Dynamic rule-based workflows and intelligent event processing (rule-based CEP)',
	 'Non-functional requirements; use of annotations; metadata to capture those',
	 'Design time and execution time aspects of rule-based (Semantic) Business Processes Modeling and Management',
	 'Practical and business aspects of rule-based (Semantic) Business Process Management (business scenarios; case studies; use cases etc)']).
session('Rule-Based Distributed/Multi-Agent Systems',
	['rule-based specification and verification of Distributed/Multi-Agent Systems',
	 'rule-based distributed reasoning and problem solving',
	 'rule-based agent architectures',
	 'rules and ontologies for semantic agents',
	 'rule-based interaction protocols for multi-agent systems',
	 'rules for service-oriented computing (discovery; composition; etc)',
	 'rule-based cooperation; coordination and argumentation in multi-agent systems',
	 'rule-based e-contracting and negotiation strategies in multi-agent systems',
	 'rule interchange and reasoning interoperation in heterogeneous Distributed/Multi-Agent Systems']).
session('General Introduction to Rules',
	['Rules and ontologies',
	 'Execution models; rule engines; and environments',
	 'Graphical processing; modeling and rendering of rules']).
session('RuleML-2010 Challenge',
	['benchmarks/evaluations; demos; case studies; use cases; experience reports; best practice solutions (design patterns; reference architectures; models)',
	 'rule-based implementations; tools; applications; demonstrations engineering methods',
	 'implementations of rule standards (RuleML; RIF; SBVR; PRR; rule-based Event Processing languages; BPMN and rules; BPEL and rules); rules and industrial standards (XBRL; MISMO; Accord) and industrial problem statements',
	 'Modelling Rules in the Temporal and Geospatial Applications',
	 'temporal modelling and reasoning; geospatial modelling and reasoning',
	 'cross-linking between temporal and geospatial knowledge',
	 'visualization of rules with graphic models in order to support end-user interaction',
	 'Demos related to various Rules topics',
	 'Extensions and implementations of W3C RIF',
	 'Editing environments and IDEs for Web rules',
	 'Benchmarks and comparison results for rule engines',
	 'Distributed rule bases and rule services',
	 'Reports on industrial experience about rule systems']).
