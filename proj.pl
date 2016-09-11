/* Moustakas Aristeidis  AEM: 2380 */

/*To ���������� query ������� ��� ������ ��� ����� ��� keywords, ����� �� ���������� preparation ���� �� ��� ��������� �� �� ��������� format �� �� ����, ����� ��� startComputeScores ���� �� ���������� �� score ���� session �� ���� ��� ����� �� �� keywords, ����� ��� qsort ��� �� ����������� ��� ����� �� �� scores ��� ����� ����� ��� printScores ���� �� ��������� ��� ����� �� ��� ��������� �����.*/
query(L):-
	preparation(L,FL),
	startComputeScores(FL,ScoreList),
	qsort(ScoreList,SortedScoreList),
	printScores(SortedScoreList),!.


/*To ���������� preparation ����� ��� prep �������� ��� �� 1� ������ ��� ����� �� �� keywordwors ���� ���� �� ����� � �������, (2� ������ ��� ����� ���  �� ���� ���� �� ������ ������������ ��� ��� ���� ����� ��� �� �������������� �� temp ����� ��� ��������� ������������.    */


preparation([X|S],Res):- prep([X|S],Res,[]).


/*To ���������� prep ������� �� ����� ������ ��� ����� �� �� keywords , ��� ����� TempRes ��� �� �������� ��������� ������������ ����� ������ ��� ������ ��� ��� ����� Res ��� �� ���� ��� ������ ����� �� �� keywords ��� ��������� format ��� �� �� ��������� ����  .A� �� keyword ��� ����� ������ ��� ��� � ������ ��� ������ �� �� keywords ���� ������ ����� ����������� �� �� prep([X-W|S],Res,TempRes) ������ �� ��� ���� ����� �� �� prep([X|S],Res,TempRes) ��� ��������� ��� ���� ����� 1. �� ����������� ��� �� 2 ������������ ��� �� ���������� �������� � tokenize_atom ���� �� ���������� �� keywords �� ��� ����� ��� ������ ��� ���� ���� �������� ������� ��� length ��� ����� ��� ����� ��� ��� ������ (���������� �� length �������������� ��� �� �� keyword ����� ����� � ����). ���� �������� �������� �� ���������� addInFinalList ��� ������� ��� ������ ��� ����-����� , ��� ����� ��� ����������� � tokenize_atom, �� length ��� ������ , �� ����� ��� ����� ������ ��� 2 ������ , ��� TempRes ��� �� �������� ��������� ������������ ��� ��� �Res ��� �� ���� ��� ������ ����� ��� �� ���� ���� �� keywords ��� ��������� format ��� �� �� ��������� ����. ����� �������� �� prep ���������� ��� ��� ���� ��� ������. ���� ����������� ����� ��  �� �������� � ����� �� �� keywords ������ �� ����� ��������� �� �� prep([],Res,Res) ���� ��� � ��������� ����� ���� ����� (�empRes) ������������ ��� ������ ����� (Res).
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


/*To ���������� addInFinalList ������� ��� �������� ��� ����-����� (�), ��� ����� ��� ��� ������ ([S] � List) ��� �����-������, �� ����� ����� ��� ������, �� ����� ��� �����-������, ��� ����� Current ��� �������� ��� ������� ������� ������ ������� ��� ����������� ����������� ��� ��� ����� Res ��� ��� �� ����� � Current ������� ����� append ������� ���� ������ ������� �� �� ���� ����. �� �� keyword ����� ���� ��� ���� ��� ��� �������� ����� ������� ��������� �� ���� ��� ���� 2 ������� ������� ������� �� �� �� ���� ���� ��� ����� � ��� ���� ������� append ( ���� ���� ���������� ���� ����� keyword-weight) �� ��� Current ����� ��� �� ���������� ������������ ���� Res �����. �� �� keyword ����� ����� ������� ��������� �� ��� 3� ������ ���� ���� �������� �� ���������� phrasePrep �� ����� ������ ��� ����� �� ��� ������ ��� ������ ��� ��� Current �����  ��� ���������� ��� ����� ��� �������� ���� ��� ������ ��� ������ ��������� ��� �� �� ��������� ���� ������� ��� ����� append �� ��� Current ����� .����� � ����� ��� ����� ��� ��������� � phrasePrep ������� append ��� �������� ��� ����� �� �� ��������� ����� ���.	 */


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



/*To ���������� phrasePrep ������ ��� ������ ��� ����� �� ��� ������ ��� ������, �� ����� ����� ��� ������ , �� ����� ����� ��� ������, ��� Current ����� ��� �������� �� ������������ ����� ������ ��� ������. ���� �������� ���������� ( ���������� ) ��� ����� �� �� keywords ��� �� ��������� ���� ��� ��� ����� append �� ��� Current �����. ����� ����� ���������� ����� ��� ����� ��� ����������� �� ��� ��������� Res ��� �� �������� ��� �� ������ ����� ��� ���������� ( ��������� ������� ).  */

phrasePrep([],_,_,Res,Res):-!.
phrasePrep([X|SubList],Len,W,Current,Res):-
	R is W/Len,
	Q=X-R,
	append(Current,[Q],TempRes),
	phrasePrep(SubList,Len,W,TempRes,Res).




/*To startComputeScores ������� ��� ������ ��� ��������� �������������� ����� �� �� keywords ��� ���������� ��� ������ ����� ��� �� �� �� scores ��� �� ���� session. ���� ������� ��������������� �� ���������� findall �� ����� �� �������� ��� �� scores ��� �� ��������� ��� �� backtracking ���� �� ������ ������������� session. To findall ������� ��� ������ �� ����� ��� �� ������������ ��� �� ����������� ���� ����� �� ���� backtracking ( S ), �� ���������� ��� �� ���������������� (computeScores(Keywords,S)) ��� ��� ����� �� ��� �� �������� �� ������ scores (ScoreList).*/

startComputeScores(Keywords,ScoreList):-findall(S,computeScores(Keywords,S),ScoreList).


/*To ���������� computeScores ������� ��� ������ ��� ����� �� ��� �� keywords ��� ���������� ��� ��������� S ��� �� �������� ��� ����� ��� score ������� ������������� session. A����� ������� ������� �� ��� ����� ��� ��� ����� ��� �� topics ������� session (session(Title,Topics)), ���� �������� �������� �� ���������� phraseScore (�� ����� ���������� �� score ���� ������) ��� ���������� �� score ��� ������ �� ����� ���� �������� ����������������  ��� 2 ���  ������ ����� �� ����������  topicsScore �� ����� ���������� �� score ���� ��� ���������� ����������(��� �� max score ��� ���� ������ �������).����� ��������� �� max ������� ��� max ��� ���������� ��� �� score ��� ������ ��� ������������ �� score ��� �� ������������ session (Tscore is TitleScoreX2+TopicsScore+1000*FScore). T���� ���������� ���� ��������� S �� �� Title-Tscore.*/


computeScores(Keywords,S):-
	session(Title,Topics),
	phraseScore(Keywords,Title,0,TitleScore),
	TitleScoreX2 is 2*TitleScore,
	topicsScore(Keywords,Topics,0,TopicsScore,0,Max),
	max(TitleScoreX2,Max,FScore),
	Tscore is TitleScoreX2+TopicsScore+1000*FScore,
	S=Title-Tscore.

/* �� ���������� topicsScore ������� ��� ����� ��� �eywords ��� ��� ����� ��� topics ������� session ��� ����������( ���������� ) �� �������� ��� scores ��� ������������� ���� �� topics ��� �� ������������ keywords. ������ ������� ��� max ���� �� ������� ��� ����� �� ������� score ��� ������������� ��� ������ ��� �� topics.   */

topicsScore(_Keywords,[],Score,Score,Max,Max):-!.
topicsScore(Keywords,[T|Topics],Temp,Score,Tmax,Max):-
	phraseScore(Keywords,T,0,S),
	max(Tmax,S,TempMax),
	Tt is Temp + S,
	topicsScore(Keywords,Topics,Tt,Score,TempMax,Max).




/* �� ���������� max ������� 2 ����� X ��� Y ���������� �� ��� ����� ��������� ��� ���������� ��� �����.*/
max(X,Y,X) :- X>Y,!.
max(X,Y,Y) :- X=<Y.




/*To ���������� phraseScore ���������� ( ���������� )�� score ���� ������ �� ���� ��� ������������ ����� ��� keywords. ��� ������������ ��� ������� �� keyword (��� ��������� ���� ������ ��� ������ ��� keywords) ���� ���� ����� ���� ����������� �� ����� ��� �� ��� ��������� temp � ����� �������� �� score ��� ������������ ����� ���� �� ����� �� ����� �� ��� temp. �� ��� ������� ���� �������� � 3�� ������� ��� ��� ������� ����, ���� ������� ���������� ����� �� �� ���� temp. ����� ������� ���� ������� ����������� ����� ��������� ��� �� keywords ��� ������� ��������� ��� ���������� score (temp) ��� ������ ���������� (Score). */

phraseScore([],_,Score,Score):-!.
phraseScore([Key-Weight|SubList],Phrase,TempScore,Score):-
	sub_string(case_insensitive,Key,Phrase),
	T is Weight+TempScore,
	phraseScore(SubList,Phrase,T,Score),!.
phraseScore([_Key-_Weight|SubList],Phrase,TempScore,Score):-
	phraseScore(SubList,Phrase,TempScore,Score).









/*�� ���������� qsort (���� �� �� ���������� split, ��� �� 2 ���� ��������� ��� quicksort) ������� �� ������ ��� ����� ��� ����� ���������� �� ���� �� Score ��� �� ������� ��������� �� ���� ��� ����� ��� ���� ��������  ���������� ����� ��� ������������ ����� ���� ��������� Sorted. */

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




/* ������� ��� ������ ��� ����� �� �� ������ Scores ��� ��� ��������� ��� ��������� format.*/


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
