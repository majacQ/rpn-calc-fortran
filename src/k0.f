      module k0

      implicit none (type, external)
      private
      public:: besk0

      contains

      SUBROUTINE CALCK0(ARG,RESULT,JINT)
C--------------------------------------------------------------------
C
C This packet computes modified Bessel functions of the second kind
C   and order zero, K0(X) and EXP(X)*K0(X), for real
C   arguments X.  It contains two function type subprograms, BESK0
C   and BESEK0, and one subroutine type subprogram, CALCK0.
C   the calling statements for the primary entries are
C
C                   Y=BESK0(X)
C   and
C                   Y=BESEK0(X)
C
C   where the entry points correspond to the functions K0(X) and
C   EXP(X)*K0(X), respectively.  The routine CALCK0 is
C   intended for internal packet use only, all computations within
C   the packet being concentrated in this routine.  The function
C   subprograms invoke CALCK0 with the statement
C          CALL CALCK0(ARG,RESULT,JINT)
C   where the parameter usage is as follows
C
C      Function                     Parameters for CALCK0
C       Call              ARG                  RESULT          JINT
C
C     BESK0(ARG)   0 .LT. ARG .LE. XMAX       K0(ARG)           1
C     BESEK0(ARG)     0 .LT. ARG           EXP(ARG)*K0(ARG)     2
C
C   The main computation evaluates slightly modified forms of near
C   minimax rational approximations generated by Russon and Blair,
C   Chalk River (Atomic Energy of Canada Limited) Report AECL-3461,
C   1969.  This transportable program is patterned after the
C   machine-dependent FUNPACK packet NATSK0, but cannot match that
C   version for efficiency or accuracy.  This version uses rational
C   functions that theoretically approximate K-SUB-0(X) to at
C   least 18 significant decimal digits.  The accuracy achieved
C   depends on the arithmetic system, the compiler, the intrinsic
C   functions, and proper selection of the machine-dependent
C   constants.
C
C*******************************************************************
C*******************************************************************
C
C Explanation of machine-dependent constants
C
C   beta   = Radix for the floating-point system
C   minexp = Smallest representable power of beta
C   maxexp = Smallest power of beta that overflows
C   XSMALL = Argument below which BESK0 and BESEK0 may
C            each be represented by a constant and a log.
C            largest X such that  1.0 + X = 1.0  to machine
C            precision.
C   XINF   = Largest positive machine number; approximately
C            beta**maxexp
C   XMAX   = Largest argument acceptable to BESK0;  Solution to
C            equation:
C               W(X) * (1-1/8X+9/128X**2) = beta**minexp
C            where  W(X) = EXP(-X)*SQRT(PI/2X)
C
C
C     Approximate values for some important machines are:
C
C
C                           beta       minexp       maxexp
C
C  CRAY-1        (S.P.)       2        -8193         8191
C  Cyber 180/185
C    under NOS   (S.P.)       2         -975         1070
C  IEEE (IBM/XT,
C    SUN, etc.)  (S.P.)       2         -126          128
C  IEEE (IBM/XT,
C    SUN, etc.)  (D.P.)       2        -1022         1024
C  IBM 3033      (D.P.)      16          -65           63
C  VAX D-Format  (D.P.)       2         -128          127
C  VAX G-Format  (D.P.)       2        -1024         1023
C
C
C                          XSMALL       XINF         XMAX
C
C CRAY-1        (S.P.)    3.55E-15   5.45E+2465    5674.858
C Cyber 180/855
C   under NOS   (S.P.)    1.77E-15   1.26E+322      672.788
C IEEE (IBM/XT,
C   SUN, etc.)  (S.P.)    5.95E-8    3.40E+38        85.337
C IEEE (IBM/XT,
C   SUN, etc.)  (D.P.)    1.11D-16   1.79D+308      705.342
C IBM 3033      (D.P.)    1.11D-16   7.23D+75       177.852
C VAX D-Format  (D.P.)    6.95D-18   1.70D+38        86.715
C VAX G-Format  (D.P.)    5.55D-17   8.98D+307      706.728
C
C*******************************************************************
C*******************************************************************
C
C Error returns
C
C  The program returns the value XINF for ARG .LE. 0.0, and the
C  BESK0 entry returns the value 0.0 for ARG .GT. XMAX.
C
C
C  Intrinsic functions required are:
C
C     EXP, LOG, SQRT
C
C  Latest modification: March 19, 1990
C
C  Authors: W. J. Cody and Laura Stoltz
C           Mathematics and Computer Science Division
C           Argonne National Laboratory
C           Argonne, IL 60439
C
C--------------------------------------------------------------------
      INTEGER I,JINT
CS    REAL
      DOUBLE PRECISION
     1    ARG,F,G,ONE,P,PP,Q,QQ,RESULT,SUMF,SUMG,SUMP,SUMQ,TEMP,
     2    X,XINF,XMAX,XSMALL,XX,ZERO
      DIMENSION P(6),Q(2),PP(10),QQ(10),F(4),G(3)
C--------------------------------------------------------------------
C  Mathematical constants
C--------------------------------------------------------------------
CS    DATA ONE/1.0E0/,ZERO/0.0E0/
      DATA ONE/1.0D0/,ZERO/0.0D0/
C--------------------------------------------------------------------
C  Machine-dependent constants
C--------------------------------------------------------------------
CS    DATA XSMALL/5.95E-8/,XINF/3.40E+38/,XMAX/ 85.337E0/
      DATA XSMALL/1.11D-16/,XINF/1.79D+308/,XMAX/705.342D0/
C--------------------------------------------------------------------
C
C     Coefficients for XSMALL .LE.  ARG  .LE. 1.0
C
C--------------------------------------------------------------------
CS    DATA   P/ 5.8599221412826100000E-04, 1.3166052564989571850E-01,
CS   1          1.1999463724910714109E+01, 4.6850901201934832188E+02,
CS   2          5.9169059852270512312E+03, 2.4708152720399552679E+03/
CS    DATA   Q/-2.4994418972832303646E+02, 2.1312714303849120380E+04/
CS    DATA   F/-1.6414452837299064100E+00,-2.9601657892958843866E+02,
CS   1         -1.7733784684952985886E+04,-4.0320340761145482298E+05/
CS    DATA   G/-2.5064972445877992730E+02, 2.9865713163054025489E+04,
CS   1         -1.6128136304458193998E+06/
      DATA   P/ 5.8599221412826100000D-04, 1.3166052564989571850D-01,
     1          1.1999463724910714109D+01, 4.6850901201934832188D+02,
     2          5.9169059852270512312D+03, 2.4708152720399552679D+03/
      DATA   Q/-2.4994418972832303646D+02, 2.1312714303849120380D+04/
      DATA   F/-1.6414452837299064100D+00,-2.9601657892958843866D+02,
     1         -1.7733784684952985886D+04,-4.0320340761145482298D+05/
      DATA   G/-2.5064972445877992730D+02, 2.9865713163054025489D+04,
     1         -1.6128136304458193998D+06/
C--------------------------------------------------------------------
C
C     Coefficients for  1.0 .LT. ARG
C
C--------------------------------------------------------------------
CS    DATA  PP/ 1.1394980557384778174E+02, 3.6832589957340267940E+03,
CS   1          3.1075408980684392399E+04, 1.0577068948034021957E+05,
CS   2          1.7398867902565686251E+05, 1.5097646353289914539E+05,
CS   3          7.1557062783764037541E+04, 1.8321525870183537725E+04,
CS   4          2.3444738764199315021E+03, 1.1600249425076035558E+02/
CS    DATA  QQ/ 2.0013443064949242491E+02, 4.4329628889746408858E+03,
CS   1          3.1474655750295278825E+04, 9.7418829762268075784E+04,
CS   2          1.5144644673520157801E+05, 1.2689839587977598727E+05,
CS   3          5.8824616785857027752E+04, 1.4847228371802360957E+04,
CS   4          1.8821890840982713696E+03, 9.2556599177304839811E+01/
      DATA  PP/ 1.1394980557384778174D+02, 3.6832589957340267940D+03,
     1          3.1075408980684392399D+04, 1.0577068948034021957D+05,
     2          1.7398867902565686251D+05, 1.5097646353289914539D+05,
     3          7.1557062783764037541D+04, 1.8321525870183537725D+04,
     4          2.3444738764199315021D+03, 1.1600249425076035558D+02/
      DATA  QQ/ 2.0013443064949242491D+02, 4.4329628889746408858D+03,
     1          3.1474655750295278825D+04, 9.7418829762268075784D+04,
     2          1.5144644673520157801D+05, 1.2689839587977598727D+05,
     3          5.8824616785857027752D+04, 1.4847228371802360957D+04,
     4          1.8821890840982713696D+03, 9.2556599177304839811D+01/
C--------------------------------------------------------------------
      X = ARG
      IF (X .GT. 0) THEN
            IF (X .LE. 1) THEN
C--------------------------------------------------------------------
C     0.0 .LT.  ARG  .LE. 1.0
C--------------------------------------------------------------------
                  TEMP = LOG(X)
                  IF (X .LT. XSMALL) THEN
C--------------------------------------------------------------------
C     Return for small ARG
C--------------------------------------------------------------------
                        RESULT = P(6)/Q(2) - TEMP
                     ELSE
                        XX = X * X
                        SUMP = ((((P(1)*XX + P(2))*XX + P(3))*XX +
     1                         P(4))*XX + P(5))*XX + P(6)
                        SUMQ = (XX + Q(1))*XX + Q(2)
                        SUMF = ((F(1)*XX + F(2))*XX + F(3))*XX + F(4)
                        SUMG = ((XX + G(1))*XX + G(2))*XX + G(3)
                        RESULT = SUMP/SUMQ - XX*SUMF*TEMP/SUMG - TEMP
                        IF (JINT .EQ. 2) RESULT = RESULT * EXP(X)
                  END IF
               ELSE IF ((JINT .EQ. 1) .AND. (X .GT. XMAX)) THEN
C--------------------------------------------------------------------
C     Error return for ARG .GT. XMAX
C--------------------------------------------------------------------
                  RESULT = 0
               ELSE
C--------------------------------------------------------------------
C     1.0 .LT. ARG
C--------------------------------------------------------------------
                  XX = 1 / X
                  SUMP = PP(1)
                  DO 120 I = 2, 10
                     SUMP = SUMP*XX + PP(I)
  120             CONTINUE
                  SUMQ = XX
                  DO 140 I = 1, 9
                     SUMQ = (SUMQ + QQ(I))*XX
  140             CONTINUE
                  SUMQ = SUMQ + QQ(10)
                  RESULT = SUMP / SUMQ / SQRT(X)
                  IF (JINT .EQ. 1) RESULT = RESULT * EXP(-X)
            END IF
         ELSE
C--------------------------------------------------------------------
C     Error return for ARG .LE. 0.0
C--------------------------------------------------------------------
            RESULT = XINF
      END IF
C--------------------------------------------------------------------
C     Update error counts, etc.
C--------------------------------------------------------------------
      RETURN
C---------- Last line of CALCK0 ----------
      END SUBROUTINE CALCK0
CS    REAL
      DOUBLE PRECISION    FUNCTION BESK0(X)
C--------------------------------------------------------------------
C
C This function program computes approximate values for the
C   modified Bessel function of the second kind of order zero
C   for arguments 0.0 .LT. ARG .LE. XMAX (see comments heading
C   CALCK0).
C
C  Authors: W. J. Cody and Laura Stoltz
C
C  Latest Modification: January 19, 1988
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION     X, RESULT
C--------------------------------------------------------------------
      JINT = 1
      CALL CALCK0(X,RESULT,JINT)
      BESK0 = RESULT
      RETURN
C---------- Last line of BESK0 ----------
      END FUNCTION BESK0
CS    REAL
      DOUBLE PRECISION     FUNCTION BESEK0(X)
C--------------------------------------------------------------------
C
C This function program computes approximate values for the
C   modified Bessel function of the second kind of order zero
C   multiplied by the Exponential function, for arguments
C   0.0 .LT. ARG.
C
C  Authors: W. J. Cody and Laura Stoltz
C
C  Latest Modification: January 19, 1988
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION  X, RESULT
C--------------------------------------------------------------------
      JINT = 2
      CALL CALCK0(X,RESULT,JINT)
      BESEK0 = RESULT
      RETURN
C---------- Last line of BESEK0 ----------
      END FUNCTION BESEK0

      end module k0
