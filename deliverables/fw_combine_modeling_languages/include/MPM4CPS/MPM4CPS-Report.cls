% MPM4CPS-Report.cls
% ------------------
% LaTeX Class to generate reports for the MPM4CPS project
%
% CERepGen settings:
% Example files: no
% Line numbers: no
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{include/MPM4CPS/MPM4CPS-Report}[2010/05/30 MPM4CPS Report document class v1.1]

%% Pass given options to derived class 
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{include/files/Report}}
\ProcessOptions

% Derive the from Report
\LoadClass{include/files/Report}

%% Packages required by MPM4CPS-Report
\RequirePackage{fancyhdr}	% The package provides facilities for constructing headers and footers
\RequirePackage{lastpage}	% Reference the number of pages in your LaTeX document
\RequirePackage{colortbl}	% Allows rows and columns to be coloured, and even individual cells. 
\RequirePackage{tabularx}	% Adds possibility to maximize the width of columns (and enables word wrap)

\setcounter{secnumdepth}{4}

%% MPM4CPS-Report specific settings
\setauthor{MPM4CPS}
\settitle{MPM4CPS report}
\setauthoraffiliation{MPM4CPS}
\setkeywords{MPM4CPS, multiparadigm modelling, cyber-physical systems} 
\def\docdate{\today}
\def\docversion{-}
\def\docname{\jobname%
\ifpdf%
.pdf
\else%
.dvi
\fi
}
\def\docpages{\pageref{LastPage}}

% Deliverable number
\newcommand{\setdeliverablenumber}[1]{\def\docdeliverablenumber{#1}}

% Dissemination level
\newcommand{\setdisseminationlevel}[1]{\def\docdisseminationlevel{#1}}

% Beneficiary responsable for the report
\newcommand{\setleadbeneficiary}[1]{\def\leadbeneficiary{#1}}

% Status: draft or final
\def\docstatus{\iffinalversion{Final}\else{Draft}\fi}



%% Redefine plain page style 
\fancypagestyle{plain}{
\fancyhf{}
\renewcommand{\headrulewidth}{0pt} % Remove line on the plain style
}


%% Define new chapter style (only logo)
\fancypagestyle{chapterstyle}{
\fancyhf{}
\setlength{\headheight}{0.7cm+0.15cm} % Change height for image
\fancyhead[LE,RO]{\includegraphics[height=0.7cm]{include/MPM4CPS/MPM4CPS-Logo}}
\renewcommand{\headrulewidth}{0pt} % Remove line on the plain style
\fancyfoot[LE,RO]{\thepage}
}

%% Define pagestyle
\pagestyle{fancy}
\fancyhf{}
\setlength{\headheight}{0.7cm+0.15cm} % Change height for image
\addtolength{\textheight}{12pt-0.65cm} % shorten text area, to compensate for larger header
\fancyhead[LO]{\bfseries\doctitle}
\fancyhead[RE]{\bfseries\leftmark}
\fancyhead[LE,RO]{\includegraphics[height=0.7cm]{include/MPM4CPS/MPM4CPS-Logo}}
\fancyfoot[LE,RO]{\thepage}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ #1}{}}

%% Change pagestyle for \chapter
\let\old@makechapterhead\@makechapterhead
\def\@makechapterhead{%
\thispagestyle{chapterstyle}
\old@makechapterhead
}

%% Change pagestyle for \chapter*
\let\old@makeschapterhead\@makeschapterhead
\def\@makeschapterhead{%
\thispagestyle{chapterstyle}
\old@makeschapterhead
}

%% Technical Note instead of Deliverable, using this Latex if: \technotetrue in main tex
\newif\iftechnote
% default to original behaviour
\technotefalse
\newcommand{\doctype}{\iftechnote{Technical Note}\else{Deliverable}\fi}

%% Change 'titlepage' into a page containing the document information
\def\maketitle{
\createdocinfo
}

\def\createdocinfo{
\thispagestyle{plain}

~			% some 'normal' text first, as otherwise, vspace() does not work
\vspace{1cm}

\begin{center}
\includegraphics[height=6.6cm]{include/MPM4CPS/MPM4CPS-Logo}
\hspace{1.0cm}
\includegraphics[scale=0.3]{include/MPM4CPS/COST}
\end{center}

\begin{center}
\textbf{ICT COST Action IC1404} \\

\vspace{1cm} 

%title, authors
{\Huge\bfseries\doctitle}

\vspace{1cm}

{\Large\docauthor}

\vspace{0.5cm}
% removed $$ around this % KGP 2010/10/06
\iftechnote{\Large \doctype\\ Document Number: \docdeliverablenumber}\else{\Large \doctype: \docdeliverablenumber}\fi

\end{center}


\capstartfalse % suppress caption

% List of Core Parnters.... Or leave them all out....

\begin{table}[b!]
	\begin{tabularx}{\linewidth}{lXll}
	 \textbf{Core Team}					&	&	\textbf{Document Info}& \\  
	 University of Antwerp, Belgium		&	&	\doctype      & \docdeliverablenumber \\
	 New University of Lisbon, Portugal			&	&	Dissemination & \docdisseminationlevel\\ 
	 Telecom ParisTech, Paris, France &	&	Status	      & \docstatus \\ 
	 Hasso-Plattner Inst., Potsdam, Germany	&	&	Doc's Lead Partner &  \leadbeneficiary \\ 
	 University of Geneva, Switzerland	&	&	Date 		  & \docdate \\
	 Charles University, Prague, Czech Republic	&	&	Version	 	  & \docversion \\ 
	 University of Manchester, UK		&	&	Pages     	  & \docpages \\
	 University of Namur, Belgium		&	&     	  & \\
	 Wageningen University, Netherlands		&	&     	  & \\
	 University of Coimbra, Portugal		&	&     	  & \\
	 Ege University, Izmir, Turkey		&	&     	  & \\
	 University of Campania Luigi Vanvitelli, Caserta, Italy	&	&     	  & \\
	 Tallinn University of Technology, Estonia	&	&     	  & \\
	 Chalmers University of Technology, Goteborg, Sweden	&	&     	  & \\
	\end{tabularx}
\end{table}

%\capstarttrue  % enable captions

\newpage

\vskip0.5cm
\if\@changelog\relax\else
\begin{tabularx}{\linewidth}[h!]{| l | l | l | X |}
\rowcolor[gray]{.8}\hline
\textbf{Ver} & \textbf{Date} & \textbf{Author} & \textbf{Description} \\\hline
\@changelog
\end{tabularx}
\vskip0.5cm
\fi
}

\def\@changelog{\relax}
% #1: version
% #2: date
% #3: author
% #4: description
\def\addversion#1#2#3#4{
\expandafter\def\expandafter\@changelog\expandafter{\@changelog
#1 & #2 & #3 & #4 \\\hline
}
\def\docversion{#1}
}
% Dutch style of paragraph formatting, i.e. no indents. 
\setlength{\parskip}{1.3ex plus 0.2ex minus 0.2ex}
\setlength{\parindent}{0pt}

%% Space between paragraphs
\setlength{\parskip}{0.33\baselineskip}
