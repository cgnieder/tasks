% --------------------------------------------------------------------------
% the TASKS package
% 
%   lists with columns filled horizontally
% 
% --------------------------------------------------------------------------
% Clemens Niederberger
% Web:    https://github.com/cgnieder/tasks/
% E-Mail: contact@mychemistry.eu
% --------------------------------------------------------------------------
% Copyright 2013--2021 Clemens Niederberger
% 
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
% 
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Clemens Niederberger.
% --------------------------------------------------------------------------
% If you have any ideas, questions, suggestions or bugs to report, please
% feel free to contact me.
% --------------------------------------------------------------------------
\ProvidesClass{tasks-manual}[2022/01/08]

\LoadClass[load-preamble,add-index]{cnltx-doc}
\RequirePackage{imakeidx}

\RequirePackage{tasks}

\setcnltx{
  package  = {tasks} ,
  authors  = Clemens Niederberger ,
  email    = {contact@mychemistry.eu} ,
  url      = {https://github.com/cgnieder/tasks/} ,
  info     = {lists with columns filled horizontally} ,
  add-cmds = {
    NewTasksEnvironment,
    RenewTasksEnvironment,
    settasks,
    startnewitemline ,
    task
  } ,
  add-silent-cmds = {
    DeclareInstance, DeclareTemplateInterface,
    faThumbsOUp,
    sample, Sample , theexercise
  } ,
  index-setup = { othercode=\footnotesize, level=\section , noclearpage } ,
  makeindex-setup = { columns=3, columnsep=1em }
}

\def\libertine@figurestyle{LF}
\RequirePackage{amsmath}
\undef\lvert \undef\lVert
\undef\rvert \undef\rVert
\RequirePackage[libertine]{newtxmath}
\def\libertine@figurestyle{OsF}

\newpackagename\ExSheets{ExSheets}
\newpackagename\Tasks{tasks}

% ----------------------------------------------------------------------------
% other packages, bibliography, index
\RequirePackage{xcoffins,tikz,wasysym,enumitem,booktabs,siunitx,accsupp}
\RequirePackage{acro}
\DeclareAcronym{id}{
  short     = id ,
  long      = Identifier ,
  format    = \scshape ,
  pdfstring = ID ,
  short-acc = ID
}

\RequirePackage{csquotes}

% ----------------------------------------------------------------------------
% example definitions that have to be done in the preamble:
\RequirePackage{xsim}

\newcommand*\sample{This is some sample text we will use to create a somewhat
  longer text spanning a few lines.}
\newcommand*\Sample{\sample\ \sample\par\sample}

\RequirePackage{fontawesome}
\RequirePackage{datetime2}
\DTMsetup{useregional=numeric,datesep=/}
\newrobustcmd*\tasks@add@version[2]{%
  \csdef{tasks@ver@#2}{%
    \DTMdate{#1}%
    \csgdef{tasks@ver@#2used}{}%
    \csdef{tasks@ver@#2}{\DTMdate{#1}}%
  }%
}

\newrobustcmd*\tasks@date[1]{%
  \ifcsdef{tasks@ver@#1used}{}{ (\csuse{tasks@ver@#1})}}
\newrobustcmd*\tasks@ifnew[1]{\ifcsstring{c_tasks_version_tl}{#1}}
\newrobustcmd*\tasks@NEW{\textcolor{red}{\faStarO\ New}}

\renewrobustcmd*\sinceversion[1]{%
  \tasks@ifnew{#1}%
    {\cnltx@version@note{\tasks@NEW}}%
    {\cnltx@version@note{introduced in v#1\tasks@date{#1}}}%
}
\renewrobustcmd*\changedversion[1]{%
  \cnltx@version@note{updated in v#1\tasks@date{#1}}%
}

\newnote*\sincechanged[2]{%
  introduced in v#1 and updated in v#2\tasks@date{#2}%
}

\RenewDocumentEnvironment{commands}{}
  {%
    \cnltx@set@catcode_{12}%
    \let\command\cnltx@command
    \cnltxlist
  }
  {\endcnltxlist}
  
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\tcbset{enhanced,enhanced jigsaw}

\newtcolorbox{bewareofthedog}{
  colback  = red!2!white!98 ,
  colframe = red ,
  underlay={%
    \path[draw=none]
      (interior.south west)
      rectangle node[red]{\Huge\bfseries !}
      ([xshift=-4mm]interior.north west);
    }%
}

\newtcolorbox{cnltxcode}[1][]{
  boxrule = 1pt ,
  colback = cnltxbg ,
  colframe = cnltx ,
  arc = 5pt ,
  beforeafter skip = .5\baselineskip ,%
  #1%
}

\newcommand*\tasks@readoptions[1]{%
  \catcode`\^^M=13
  \tasks@read@options{#1}%
}

\begingroup
\catcode`\^^M=13
\gdef\tasks@read@options#1#2^^M{%
  \ifblank{#2}{}{\tasks@read@options@#2}%
  #1%
  \XSIMfilewritestart*{\jobname.tmp}%
}%
\endgroup

\def\tasks@read@options@[#1]{\pgfqkeys{/cnltx}{#1}}

\RenewDocumentEnvironment{sourcecode}{}
  {%
    \tasks@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \cnltxcode[breakable]%
    \lstinputlisting[style=cnltx]{\jobname.tmp}%
    \endcnltxcode
  }

\RenewDocumentEnvironment{example}{}
  {%
    \tasks@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \catcode`\^^M=5
    \ifbool{cnltx@sidebyside}
      {%
        \cnltxcode
        \noindent
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@source@hook
          \lstinputlisting[style=cnltx] {\jobname.tmp}%
          \cnltx@after@source@hook
        \endminipage\hfill
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@example@hook
          \input {\jobname.tmp}%
          \cnltx@after@example@hook
        \endminipage
      }
      {%
        \cnltxcode[breakable]%
        \cnltx@pre@source@hook
        \lstinputlisting{\jobname.tmp}%
        \cnltx@after@source@hook
        \tcblower
        \cnltx@pre@example@hook
        \input {\jobname.tmp}%
        \cnltx@after@example@hook
      }%
    \endcnltxcode
  }

\RequirePackage[
  backend=biber,
  style=cnltx,
  sortlocale=en_US,
  indexing=cite]{biblatex}
\RequirePackage{csquotes,varioref}
\defbibheading{bibliography}{\section{References}}
\addbibresource{cnltx.bib}

\RequirePackage[biblatex]{embrac}
\ChangeEmph{[}[,.02em]{]}[.055em,-.08em]
\ChangeEmph{(}[-.01em,.04em]{)}[.04em,-.05em]

\tasks@add@version{2013-01-19}{0.7}
\tasks@add@version{2013-04-04}{0.8a}
\tasks@add@version{2013-04-07}{0.9}
\tasks@add@version{2013-04-22}{0.9a}
\tasks@add@version{2013-12-03}{0.9b}
\tasks@add@version{2014-05-11}{0.9c}
\tasks@add@version{2014-07-20}{0.10}
\tasks@add@version{2014-07-29}{0.10a}
\tasks@add@version{2016-05-03}{0.11}
\tasks@add@version{2016-05-04}{0.11a}
\tasks@add@version{2016-08-13}{0.12}
\tasks@add@version{2016-08-16}{0.13}
\tasks@add@version{2019-10-04}{1.0}
\tasks@add@version{2019-10-05}{1.0a}
\tasks@add@version{2019-10-06}{1.0b}
\tasks@add@version{2019-10-07}{1.0c}
\tasks@add@version{2019-10-08}{1.0d}
\tasks@add@version{2019-11-03}{1.1}
\tasks@add@version{2020-01-11}{1.1a}
\tasks@add@version{2020-03-21}{1.2}
\tasks@add@version{2020-04-19}{1.2a}
\tasks@add@version{2020-08-19}{1.3}
\tasks@add@version{2021-02-20}{1.3a}
\tasks@add@version{2022-01-08}{1.4}
\tasks@add@version{2022-01-08}{1.4a}

\endinput
