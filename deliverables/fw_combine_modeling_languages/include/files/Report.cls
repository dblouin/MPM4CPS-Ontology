% Report.cls
% ----------
% LaTeX Class to generate reports (with improved chapters, PDF-support, margins, ...)
% This file is included in the class definitions and should contain class specific settings
% ie settings which defines the document type (margins, headers, footers, etc)
%
% Keep content generic for *all* Reports!
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{include/files/Report}[2009/11/06 Report document class v1.0]

%%Add [final] option to the report class to switch between draft and final version of the report
\newif\iffinalversion						%Define new if 
\finalversionfalse							%Default value is false 
\DeclareOption{final}{\finalversiontrue}	%Set to true if final option is given
% Add [lineno] option to the report class to add line numbers to each text line
\newif\iflineno								%Define new if
%\linenofalse								%Default value is false
\linenotrue                                 % KGP 2010/08/26
\DeclareOption{lineno}{\linenotrue}			%Set to true if option is given
% Add [showkeys] option to the report class to allow printing the b5 document on a4 paper in original b5 size with crop markers
\newif\ifshowkeys							%Define new if
\showkeysfalse								%Default value is false
\DeclareOption{showkeys}{\showkeystrue}		%Set to true if option is given

%% Pass other options to derived class 
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions

\LoadClass[a4paper,openany,twoside,11pt]{book}

% Load generic document settings
\input{include/files/doc_settings.tex}

%% Packages required by Reports
\RequirePackage{ifthen}
\RequirePackage{ifpdf}
\RequirePackage[svgnames,table]{xcolor}   % Color extensions, provided more (user-friendly) color commands % KGP 2010/09/30
%\RequirePackage{pstricks}		% PSTricks is a set of macros that allow the inclusion of PostScript drawings directly inside LaTeX code  % KGP 2011/06/15
\RequirePackage{calc}			% Simple arithmetic in LaTeX commands.
\RequirePackage{caption}		% Caption manipulation
\RequirePackage{natbib}			% Nice bibliography (adds \citep and \citet as well)

%% Change captions (requires caption package included by the subfig package)
% See captions.pdf for more settings, like hanging and indenting captions
\captionsetup{font={small}}
\captionsetup{labelfont={bf}}
%\captionsetup{labelsep=endash}

% Don't add extra space between the figures and their captions
% \captionsetup[figure]{skip=-3pt}
\captionsetup[figure]{skip=5pt}     % KGP 2010/08/25

%
% Conditional package includes dependent on the class options 
%_____________________________________________________________
\iffinalversion
	% Process final version stuff
\else
	% Process options for the draft mode
	\iflineno
		\RequirePackage{lineno}	% Show line numbers for reviewing purposes (Ubuntu: texlive-humanities package)
		\linenumbers[1]
	\fi % lineno
	\ifshowkeys
		\RequirePackage{showkeys}	% Show \label & \ref keys
	\fi % showkeys
\fi % finalversion

%
% Define the cleardoublepage command to empty the entire page
%____________________________________________________________
\def\cleardoublepage{%
	\clearpage%
	\if@twoside%
		\ifodd%
			\c@page%
		\else%
			\hbox{}%
			\thispagestyle{plain}%
			\newpage%
			\if@twocolumn%
				\hbox{}%
				\newpage%
			\fi%
		\fi%
	\fi%
}

%% Redefine the chapter heading layout (original in book.cls) 
% (Comments show modifications)
\def\@makechapterhead#1{%
 \vspace*{0pt}%                                           Less spacing
 {\parindent \z@ \raggedright \normalfont
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \LARGE\bfseries \textsf{\thechapter} \space%        Smaller font size chapter number
      %\par\nobreak%                                      Keep name on same line 
      %\vskip 20\p@%                                      No spacing between number and name (same line
    \fi
  \fi
  \interlinepenalty\@M
  \LARGE \bfseries \textsf{#1}\par\nobreak%               Smaller font size for chapter name 
  \vskip 10\p@%                                           Less spacing below
 }%
}%

%% Redefine the hidden chapter heading layout (original in book.cls)
% (Comments show modifications)
\def\@makeschapterhead#1{%
  \vspace*{0pt}%									% Less spacing
  {\parindent \z@ \raggedright
  	\normalfont
    \interlinepenalty\@M
    \LARGE \bfseries \textsf{#1}\par\nobreak		% Smaller chpater name
    \vskip 10\p@									% Less spacing below
  }
}%

% Grs: fix table of contents command: kick @mkboth outside the \chapter* 
%      to prevent problems with @mkboth in the \pdfbookmark command, 
%      resulting in strange characters in the bookmark list 
\renewcommand\tableofcontents{% 
    \if@twocolumn 
      \@restonecoltrue\onecolumn 
    \else 
      \@restonecolfalse 
    \fi 
    \chapter*{\contentsname} 
	\@mkboth{% 
       \MakeUppercase\contentsname}{\MakeUppercase\contentsname}% 
	\@starttoc{toc}% 
	\if@restonecol\twocolumn\fi 
} 

%% Add hidden chapters to the pdfbookmarks
\ifpdf
  \newcounter{hiddenchapter}
\fi
\let\@makeschapterhead@orig\@makeschapterhead
\def\@makeschapterhead#1{%
  \ifpdf
    \refstepcounter{hiddenchapter}
    \label{chapters.\thehiddenchapter.0}
    \schapter@addmarks{#1}
  \fi
  \@makeschapterhead@orig{#1}
}
% Separate macro for the actual addition,
% so it can be easily changed for the bibliography
\def\schapter@addmarks#1{
\pdfbookmark[0]{#1}{chapters.\thehiddenchapter}
}

% \@startsection {NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE} 
%            optional * [ALTHEADING]{HEADING}
%    Generic command to start a section.  
%    NAME       : e.g., 'subsection'
%    LEVEL      : a number, denoting depth of section -- e.g., chapter=1,
%                 section = 2, etc.  A section number will be printed if
%                 and only if LEVEL < or = the value of the secnumdepth
%                 counter.
%    INDENT     : Indentation of heading from left margin
%    BEFORESKIP : Absolute value = skip to leave above the heading.  
%                 If negative, then paragraph indent of text following 
%                 heading is suppressed.
%    AFTERSKIP  : if positive, then skip to leave below heading,
%                       else - skip to leave to right of run-in heading.
%    STYLE      : commands to set style
%  If '*' missing, then increments the counter.  If it is present, then
%  there should be no [ALTHEADING] argument.  A sectioning command
%  is normally defined to \@startsection + its first six arguments.

%% renew the other section commands as well
\renewcommand\section{\@startsection {section}{1}
                                    {\z@}   % INDENT: 0mm
                                    {1.5ex} % BEFORESKIP
                                    {0.1ex} % AFTERSKIP
                                    {\normalfont\large\bfseries}}

\renewcommand\subsection{\@startsection{subsection}{2}{0mm}%
                                    {1.5ex}%
                                    {0.1ex}%
                                    {\normalfont\normalsize\bfseries}}

\renewcommand\subsubsection{\@startsection{subsubsection}{3}{0mm}%
                                    {1ex}%
                                    {0.1ex}%
                                    {\normalfont\normalsize\bfseries}}

\renewcommand\paragraph{\@startsection{paragraph}{4}{0mm}%
                                    {1ex}%
                                    {0.03ex}%
                                    {\normalfont\normalsize\bfseries}}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{0mm}%
                                    {1ex}%
                                    {-1em}%
				                    {\normalfont\normalsize\bfseries}}

%%Redo the way LaTeX makes up the chapter and section marks
%\renewcommand{\chaptermark}[1]{%
%  \markboth{{\thechapter.\ #1}}{}}
%\renewcommand{\sectionmark}[1]{%
% \markright{#1}}

\renewcommand{\chaptermark}[1]{%
  \markboth{{#1}}{}}
\renewcommand{\sectionmark}[1]{%
 \markright{#1}}

%% Redefine itemize environment for closer spacing
%\renewenvironment{itemize}%
%  {\begin{list}{\labelitemi}%
%	  {\setlength{\leftmargin}{2.5em}%
%	   \setlength{\itemsep}{-\parsep}%
%	   \setlength{\topsep}{-\parskip}}%
%   }{\end{list}}
\renewenvironment{itemize}              % KGP 2010/08/25
{\begin{list}{\labelitemi}
  {\setlength{\leftmargin}{2.5em}
   \setlength{\itemsep}{0.3\parsep}
   \setlength{\topsep}{0.3\parskip}
  }
}{\end{list}}


%% Redefine enumerate environment for closer spacing
\renewenvironment{enumerate}%
{\begin{list}{\arabic{enumi}.}%
	  {\setlength{\leftmargin}{2.5em}%
	   \setlength{\itemsep}{-\parsep}%
	   \setlength{\topsep}{-\parskip}%%
	   \usecounter{enumi}}%
 }{\end{list}}

%% Page sizes: top to bottom
\setlength{\topmargin}{-1cm} %results in one inch topmargin
\setlength{\headheight}{14pt} %this is where the header resides
\setlength{\headsep}{22pt}
%% Start of text area
\setlength{\topskip}{0mm}
\setlength{\textheight}{245mm}
%% end of text area
\setlength{\footskip}{33pt} %equals headsep plus headheight
%\setlength{\footheight}{14pt}%this is where the footer resides

%% Page sizes, left to right
\setlength{\oddsidemargin}{0.6cm} %make room for the binding
\setlength{\evensidemargin}{0cm}  %make room for the binding 
\setlength{\textwidth}{150mm} %equal to linewidth
\setlength{\linewidth}{150mm} %equal to textwidth
%\setlength{\linespread}{1.05pt} %distance between two lines

%% Set depth of the table of contents
\setcounter{tocdepth}{1}

%% Don't jump into new paragraphs
\setlength{\parindent}{0em} % No indent
%\setlength{\parindent}{1em}

%% Space between paragraphs
\setlength{\parskip}{0.33\baselineskip}

%% Allow some tolerance in line- and page breaking
\tolerance 1414
\hbadness 1414
\emergencystretch 1.5em
\hfuzz 0.3pt
\widowpenalty=10000 % Do not allow widows (title of section of previous page)
\clubpenalty=10000  % and orphans (last line of par on new page)
\vfuzz \hfuzz
\raggedbottom

% ======================
% Bibliography settings
% ======================
% Name for the bibliography
\renewcommand{\refname}{Bibliography}

%% Modify the natbib bibliography to add a label for the pdfbookmarks
%% and removes junk from pdfbookmarks (by using \bibname instead of ##1)
% Set the space between bibitems in the bibliography
\setlength{\bibsep}{1mm}

%% Add bibliography to TOC
\let\bibliography@orig\bibliography
\def\bibliography#1{
\bgroup					% Open local scope (prevent changes to be permanent)
						% Override \schapter@addmarks to add hidden chapter to both  TOC and pdfbookmarks
\def\schapter@addmarks##1{\addcontentsline{toc}{chapter}{\bibname}}
\bibliography@orig{#1}	% Invoke original bibliography macro
\egroup					% Close local scope
}

% ============================================
% PDF settings: colors
% ============================================
\definecolor{doccrossref}{rgb}{0.00,0.00,0}   %Black
\definecolor{doccite}{rgb}{0.00,0.00,0}       %Black
\definecolor{docurl}{rgb}{0.05,0.32,0.66}     %Blue
\definecolor{docfile}{rgb}{0.05,0.32,0.66}    %Blue
\hypersetup{
	linkcolor=doccrossref,
	citecolor=doccite,
	filecolor=docfile,
	urlcolor=docurl}
