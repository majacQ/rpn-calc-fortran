      module i1

      implicit none
      private
      public:: besi1

      contains

      SUBROUTINE CALCI1(ARG,RESULT,JINT)
C--------------------------------------------------------------------
C
C This packet computes modified Bessel functioons of the first kind
C   and order one, I1(X) and EXP(-ABS(X))*I1(X), for real
C   arguments X.  It contains two function type subprograms, BESI1
C   and BESEI1, and one subroutine type subprogram, CALCI1.
C   The calling statements for the primary entries are
C
C                   Y=BESI1(X)
C   and
C                   Y=BESEI1(X)
C
C   where the entry points correspond to the functions I1(X) and
C   EXP(-ABS(X))*I1(X), respectively.  The routine CALCI1 is
C   intended for internal packet use only, all computations within
C   the packet being concentrated in this routine.  The function
C   subprograms invoke CALCI1 with the statement
C          CALL CALCI1(ARG,RESULT,JINT)
C   where the parameter usage is as follows
C
C      Function                     Parameters for CALCI1
C       Call              ARG                  RESULT          JINT
C
C     BESI1(ARG)    ABS(ARG) .LE. XMAX        I1(ARG)           1
C     BESEI1(ARG)    any real ARG        EXP(-ABS(ARG))*I1(ARG) 2
C
C   The main computation evaluates slightly modified forms of
C   minimax approximations generated by Blair and Edwards, Chalk
C   River (Atomic Energy of Canada Limited) Report AECL-4928,
C   October, 1974.  This transportable program is patterned after
C   the machine-dependent FUNPACK packet NATSI1, but cannot match
C   that version for efficiency or accuracy.  This version uses
C   rational functions that theoretically approximate I-SUB-1(X)
C   to at least 18 significant decimal digits.  The accuracy
C   achieved depends on the arithmetic system, the compiler, the
C   intrinsic functions, and proper selection of the machine-
C   dependent constants.
C
C*******************************************************************
C*******************************************************************
C
C Explanation of machine-dependent constants
C
C   beta   = Radix for the floating-point system
C   maxexp = Smallest power of beta that overflows
C   XSMALL = Positive argument such that 1.0 - X = 1.0 to
C            machine precision for all ABS(X) .LE. XSMALL.
C   XINF =   Largest positive machine number; approximately
C            beta**maxexp
C   XMAX =   Largest argument acceptable to BESI1;  Solution to
C            equation:
C               EXP(X) * (1-3/(8*X)) / SQRT(2*PI*X) = beta**maxexp
C
C
C     Approximate values for some important machines are:
C
C                          beta       maxexp       XSMALL
C
C CRAY-1        (S.P.)       2         8191       3.55E-15
C Cyber 180/855
C   under NOS   (S.P.)       2         1070       3.55E-15
C IEEE (IBM/XT,
C   SUN, etc.)  (S.P.)       2          128       2.98E-8
C IEEE (IBM/XT,
C   SUN, etc.)  (D.P.)       2         1024       5.55D-17
C IBM 3033      (D.P.)      16           63       6.95D-18
C VAX           (S.P.)       2          127       2.98E-8
C VAX D-Format  (D.P.)       2          127       6.95D-18
C VAX G-Format  (D.P.)       2         1023       5.55D-17
C
C
C                               XINF          XMAX
C
C CRAY-1        (S.P.)       5.45E+2465     5682.810
C Cyber 180/855
C   under NOS   (S.P.)       1.26E+322       745.894
C IEEE (IBM/XT,
C   SUN, etc.)  (S.P.)       3.40E+38         91.906
C IEEE (IBM/XT,
C   SUN, etc.)  (D.P.)       1.79D+308       713.987
C IBM 3033      (D.P.)       7.23D+75        178.185
C VAX           (S.P.)       1.70D+38         91.209
C VAX D-Format  (D.P.)       1.70D+38         91.209
C VAX G-Format  (D.P.)       8.98D+307       713.293
C
C*******************************************************************
C*******************************************************************
C
C Error returns
C
C  The program returns the value XINF for ABS(ARG) .GT. XMAX.
C
C
C Intrinsic functions required are:
C
C     ABS, SQRT, EXP
C
C
C  Authors: W. J. Cody and L. Stoltz
C           Mathematics and Computer Science Division
C           Argonne National Laboratory
C           Argonne, IL  60439
C
C  Latest modification: May 31, 1989
C
C--------------------------------------------------------------------
      INTEGER J,JINT
CS    REAL
      DOUBLE PRECISION
     1    A,ARG,B,EXP40,FORTY,HALF,ONE,ONE5,P,PBAR,PP,Q,QQ,REC15,
     2    RESULT,SUMP,SUMQ,TWO25,X,XINF,XMAX,XSMALL,XX,ZERO
      DIMENSION P(15),PP(8),Q(5),QQ(6)
C--------------------------------------------------------------------
C  Mathematical constants
C--------------------------------------------------------------------
CS    DATA ONE/1.0E0/,ONE5/15.0E0/,EXP40/2.353852668370199854E17/,
CS   1     FORTY/40.0E0/,REC15/6.6666666666666666666E-2/,
CS   2     TWO25/225.0E0/,HALF/0.5E0/,ZERO/0.0E0/
      DATA ONE/1.0D0/,ONE5/15.0D0/,EXP40/2.353852668370199854D17/,
     1     FORTY/40.0D0/,REC15/6.6666666666666666666D-2/,
     2     TWO25/225.0D0/,HALF/0.5D0/,ZERO/0.0D0/
C--------------------------------------------------------------------
C  Machine-dependent constants
C--------------------------------------------------------------------
CS    DATA XSMALL/2.98E-8/,XINF/3.4E38/,XMAX/91.906E0/
      DATA XSMALL/5.55D-17/,XINF/1.79D308/,XMAX/713.987D0/
C--------------------------------------------------------------------
C  Coefficients for XSMALL .LE. ABS(ARG) .LT. 15.0
C--------------------------------------------------------------------
CS    DATA P/-1.9705291802535139930E-19,-6.5245515583151902910E-16,
CS   1       -1.1928788903603238754E-12,-1.4831904935994647675E-09,
CS   2       -1.3466829827635152875E-06,-9.1746443287817501309E-04,
CS   3       -4.7207090827310162436E-01,-1.8225946631657315931E+02,
CS   4       -5.1894091982308017540E+04,-1.0588550724769347106E+07,
CS   5       -1.4828267606612366099E+09,-1.3357437682275493024E+11,
CS   6       -6.9876779648010090070E+12,-1.7732037840791591320E+14,
CS   7       -1.4577180278143463643E+15/
      DATA P/-1.9705291802535139930D-19,-6.5245515583151902910D-16,
     1       -1.1928788903603238754D-12,-1.4831904935994647675D-09,
     2       -1.3466829827635152875D-06,-9.1746443287817501309D-04,
     3       -4.7207090827310162436D-01,-1.8225946631657315931D+02,
     4       -5.1894091982308017540D+04,-1.0588550724769347106D+07,
     5       -1.4828267606612366099D+09,-1.3357437682275493024D+11,
     6       -6.9876779648010090070D+12,-1.7732037840791591320D+14,
     7       -1.4577180278143463643D+15/
CS    DATA Q/-4.0076864679904189921E+03, 7.4810580356655069138E+06,
CS   1       -8.0059518998619764991E+09, 4.8544714258273622913E+12,
CS   2       -1.3218168307321442305E+15/
      DATA Q/-4.0076864679904189921D+03, 7.4810580356655069138D+06,
     1       -8.0059518998619764991D+09, 4.8544714258273622913D+12,
     2       -1.3218168307321442305D+15/
C--------------------------------------------------------------------
C  Coefficients for 15.0 .LE. ABS(ARG)
C--------------------------------------------------------------------
CS    DATA PP/-6.0437159056137600000E-02, 4.5748122901933459000E-01,
CS   1        -4.2843766903304806403E-01, 9.7356000150886612134E-02,
CS   2        -3.2457723974465568321E-03,-3.6395264712121795296E-04,
CS   3         1.6258661867440836395E-05,-3.6347578404608223492E-07/
      DATA PP/-6.0437159056137600000D-02, 4.5748122901933459000D-01,
     1        -4.2843766903304806403D-01, 9.7356000150886612134D-02,
     2        -3.2457723974465568321D-03,-3.6395264712121795296D-04,
     3         1.6258661867440836395D-05,-3.6347578404608223492D-07/
CS    DATA QQ/-3.8806586721556593450E+00, 3.2593714889036996297E+00,
CS   1        -8.5017476463217924408E-01, 7.4212010813186530069E-02,
CS   2        -2.2835624489492512649E-03, 3.7510433111922824643E-05/
      DATA QQ/-3.8806586721556593450D+00, 3.2593714889036996297D+00,
     1        -8.5017476463217924408D-01, 7.4212010813186530069D-02,
     2        -2.2835624489492512649D-03, 3.7510433111922824643D-05/
CS    DATA PBAR/3.98437500E-01/
      DATA PBAR/3.98437500D-01/
C--------------------------------------------------------------------
      X = ABS(ARG)
      IF (X .LT. XSMALL) THEN
C--------------------------------------------------------------------
C  Return for ABS(ARG) .LT. XSMALL
C--------------------------------------------------------------------
            RESULT = HALF * X
         ELSE IF (X .LT. 15) THEN
C--------------------------------------------------------------------
C  XSMALL .LE. ABS(ARG) .LT. 15.0
C--------------------------------------------------------------------
            XX = X * X
            SUMP = P(1)
            DO 50 J = 2, 15
               SUMP = SUMP * XX + P(J)
   50          CONTINUE
            XX = XX - TWO25
            SUMQ = ((((XX+Q(1))*XX+Q(2))*XX+Q(3))*XX+Q(4))
     1           *XX+Q(5)
            RESULT = (SUMP / SUMQ) * X
            IF (JINT .EQ. 2) RESULT = RESULT * EXP(-X)
         ELSE IF ((JINT .EQ. 1) .AND. (X .GT. XMAX)) THEN
                  RESULT = XINF
         ELSE
C--------------------------------------------------------------------
C  15.0 .LE. ABS(ARG)
C--------------------------------------------------------------------
            XX = 1 / X - REC15
            SUMP = ((((((PP(1)*XX+PP(2))*XX+PP(3))*XX+
     1           PP(4))*XX+PP(5))*XX+PP(6))*XX+PP(7))*XX+PP(8)
            SUMQ = (((((XX+QQ(1))*XX+QQ(2))*XX+QQ(3))*XX+
     1           QQ(4))*XX+QQ(5))*XX+QQ(6)
            RESULT = SUMP / SUMQ
            IF (JINT .NE. 1) THEN
                  RESULT = (RESULT + PBAR) / SQRT(X)
               ELSE
C--------------------------------------------------------------------
C  Calculation reformulated to avoid premature overflow
C--------------------------------------------------------------------
                  IF (X .GT. XMAX-15) THEN
                        A = EXP(X-FORTY)
                        B = EXP40
                     ELSE
                        A = EXP(X)
                        B = 1
                  END IF
                  RESULT = ((RESULT * A + PBAR * A) /
     1                  SQRT(X)) * B
C--------------------------------------------------------------------
C  Error return for ABS(ARG) .GT. XMAX
C--------------------------------------------------------------------
            END IF
      END IF
      IF (ARG .LT. 0) RESULT = -RESULT
      RETURN
C----------- Last line of CALCI1 -----------
      END SUBROUTINE CALCI1
CS    REAL
      DOUBLE PRECISION FUNCTION BESI1(X)
C--------------------------------------------------------------------
C
C This long precision subprogram computes approximate values for
C   modified Bessel functions of the first kind of order one for
C   arguments ABS(ARG) .LE. XMAX  (see comments heading CALCI1).
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION
     1    X, RESULT
C--------------------------------------------------------------------
      JINT=1
      CALL CALCI1(X,RESULT,JINT)
      BESI1=RESULT
      RETURN
C---------- Last line of BESI1 ----------
      END FUNCTION BESI1
CS    REAL
      DOUBLE PRECISION FUNCTION BESEI1(X)
C--------------------------------------------------------------------
C
C This function program computes approximate values for the
C   modified Bessel function of the first kind of order one
C   multiplied by EXP(-ABS(X)), where EXP is the
C   exponential function, ABS is the absolute value, and X
C   is any argument.
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION
     1    X, RESULT
C--------------------------------------------------------------------
      JINT=2
      CALL CALCI1(X,RESULT,JINT)
      BESEI1=RESULT
      RETURN
C---------- Last line of BESEI1 ----------
      END FUNCTION BESEI1

      end module i1
