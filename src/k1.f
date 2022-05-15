      module k1

      implicit none (type, external)
      private
      public:: besk1

      contains

      SUBROUTINE CALCK1(ARG,RESULT,JINT)
C--------------------------------------------------------------------
C
C This packet computes modified Bessel functions of the second kind
C   and order one,  K1(X)  and  EXP(X)*K1(X), for real arguments X.
C   It contains two function type subprograms, BESK1  and  BESEK1,
C   and one subroutine type subprogram, CALCK1.  The calling
C   statements for the primary entries are
C
C                   Y=BESK1(X)
C   and
C                   Y=BESEK1(X)
C
C   where the entry points correspond to the functions K1(X) and
C   EXP(X)*K1(X), respectively.  The routine CALCK1 is intended
C   for internal packet use only, all computations within the
C   packet being concentrated in this routine.  The function
C   subprograms invoke CALCK1 with the statement
C          CALL CALCK1(ARG,RESULT,JINT)
C   where the parameter usage is as follows
C
C      Function                      Parameters for CALCK1
C        Call             ARG                  RESULT          JINT
C
C     BESK1(ARG)  XLEAST .LT. ARG .LT. XMAX    K1(ARG)          1
C     BESEK1(ARG)     XLEAST .LT. ARG       EXP(ARG)*K1(ARG)    2
C
C   The main computation evaluates slightly modified forms of near
C   minimax rational approximations generated by Russon and Blair,
C   Chalk River (Atomic Energy of Canada Limited) Report AECL-3461,
C   1969.  This transportable program is patterned after the
C   machine-dependent FUNPACK packet NATSK1, but cannot match that
C   version for efficiency or accuracy.  This version uses rational
C   functions that theoretically approximate K-SUB-1(X) to at
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
C   XLEAST = Smallest acceptable argument, i.e., smallest machine
C            number X such that 1/X is machine representable.
C   XSMALL = Argument below which BESK1(X) and BESEK1(X) may
C            each be represented by 1/X.  A safe value is the
C            largest X such that  1.0 + X = 1.0  to machine
C            precision.
C   XINF   = Largest positive machine number; approximately
C            beta**maxexp
C   XMAX   = Largest argument acceptable to BESK1;  Solution to
C            equation:
C               W(X) * (1+3/8X-15/128X**2) = beta**minexp
C            where  W(X) = EXP(-X)*SQRT(PI/2X)
C
C
C     Approximate values for some important machines are:
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
C                         XLEAST     XSMALL      XINF       XMAX
C
C CRAY-1                1.84E-2466  3.55E-15  5.45E+2465  5674.858
C Cyber 180/855
C   under NOS   (S.P.)  3.14E-294   1.77E-15  1.26E+322    672.789
C IEEE (IBM/XT,
C   SUN, etc.)  (S.P.)  1.18E-38    5.95E-8   3.40E+38      85.343
C IEEE (IBM/XT,
C   SUN, etc.)  (D.P.)  2.23D-308   1.11D-16  1.79D+308    705.343
C IBM 3033      (D.P.)  1.39D-76    1.11D-16  7.23D+75     177.855
C VAX D-Format  (D.P.)  5.88D-39    6.95D-18  1.70D+38      86.721
C VAX G-Format  (D.P.)  1.12D-308   5.55D-17  8.98D+307    706.728
C
C*******************************************************************
C*******************************************************************
C
C Error returns
C
C  The program returns the value XINF for ARG .LE. 0.0 and the
C   BESK1 entry returns the value 0.0 for ARG .GT. XMAX.
C
C
C  Intrinsic functions required are:
C
C     LOG, SQRT, EXP
C
C
C  Authors: W. J. Cody and Laura Stoltz
C           Mathematics and Computer Science Division
C           Argonne National Laboratory
C           Argonne, IL 60439
C
C  Latest modification: January 28, 1988
C
C--------------------------------------------------------------------
      INTEGER I,JINT
CS    REAL
      DOUBLE PRECISION
     1    ARG,F,G,ONE,P,PP,Q,QQ,RESULT,SUMF,SUMG,
     2    SUMP,SUMQ,X,XINF,XMAX,XLEAST,XSMALL,XX,ZERO
      DIMENSION P(5),Q(3),PP(11),QQ(9),F(5),G(3)
C--------------------------------------------------------------------
C  Mathematical constants
C--------------------------------------------------------------------
CS    DATA ONE/1.0E0/,ZERO/0.0E0/
      DATA ONE/1.0D0/,ZERO/0.0D0/
C--------------------------------------------------------------------
C  Machine-dependent constants
C--------------------------------------------------------------------
CS    DATA XLEAST/1.18E-38/,XSMALL/5.95E-8/,XINF/3.40E+38/,
CS   1     XMAX/85.343E+0/
      DATA XLEAST/2.23D-308/,XSMALL/1.11D-16/,XINF/1.79D+308/,
     1     XMAX/705.343D+0/
C--------------------------------------------------------------------
C  Coefficients for  XLEAST .LE.  ARG  .LE. 1.0
C--------------------------------------------------------------------
CS    DATA   P/ 4.8127070456878442310E-1, 9.9991373567429309922E+1,
CS   1          7.1885382604084798576E+3, 1.7733324035147015630E+5,
CS   2          7.1938920065420586101E+5/
CS    DATA   Q/-2.8143915754538725829E+2, 3.7264298672067697862E+4,
CS   1         -2.2149374878243304548E+6/
CS    DATA   F/-2.2795590826955002390E-1,-5.3103913335180275253E+1,
CS   1         -4.5051623763436087023E+3,-1.4758069205414222471E+5,
CS   2         -1.3531161492785421328E+6/
CS    DATA   G/-3.0507151578787595807E+2, 4.3117653211351080007E+4,
CS   2         -2.7062322985570842656E+6/
      DATA   P/ 4.8127070456878442310D-1, 9.9991373567429309922D+1,
     1          7.1885382604084798576D+3, 1.7733324035147015630D+5,
     2          7.1938920065420586101D+5/
      DATA   Q/-2.8143915754538725829D+2, 3.7264298672067697862D+4,
     1         -2.2149374878243304548D+6/
      DATA   F/-2.2795590826955002390D-1,-5.3103913335180275253D+1,
     1         -4.5051623763436087023D+3,-1.4758069205414222471D+5,
     2         -1.3531161492785421328D+6/
      DATA   G/-3.0507151578787595807D+2, 4.3117653211351080007D+4,
     2         -2.7062322985570842656D+6/
C--------------------------------------------------------------------
C  Coefficients for  1.0 .LT.  ARG
C--------------------------------------------------------------------
CS    DATA  PP/ 6.4257745859173138767E-2, 7.5584584631176030810E+0,
CS   1          1.3182609918569941308E+2, 8.1094256146537402173E+2,
CS   2          2.3123742209168871550E+3, 3.4540675585544584407E+3,
CS   3          2.8590657697910288226E+3, 1.3319486433183221990E+3,
CS   4          3.4122953486801312910E+2, 4.4137176114230414036E+1,
CS   5          2.2196792496874548962E+0/
CS    DATA  QQ/ 3.6001069306861518855E+1, 3.3031020088765390854E+2,
CS   1          1.2082692316002348638E+3, 2.1181000487171943810E+3,
CS   2          1.9448440788918006154E+3, 9.6929165726802648634E+2,
CS   3          2.5951223655579051357E+2, 3.4552228452758912848E+1,
CS   4          1.7710478032601086579E+0/
      DATA  PP/ 6.4257745859173138767D-2, 7.5584584631176030810D+0,
     1          1.3182609918569941308D+2, 8.1094256146537402173D+2,
     2          2.3123742209168871550D+3, 3.4540675585544584407D+3,
     3          2.8590657697910288226D+3, 1.3319486433183221990D+3,
     4          3.4122953486801312910D+2, 4.4137176114230414036D+1,
     5          2.2196792496874548962D+0/
      DATA  QQ/ 3.6001069306861518855D+1, 3.3031020088765390854D+2,
     1          1.2082692316002348638D+3, 2.1181000487171943810D+3,
     2          1.9448440788918006154D+3, 9.6929165726802648634D+2,
     3          2.5951223655579051357D+2, 3.4552228452758912848D+1,
     4          1.7710478032601086579D+0/
C--------------------------------------------------------------------
      X = ARG
      IF (X .LT. XLEAST) THEN
C--------------------------------------------------------------------
C  Error return for  ARG  .LT. XLEAST
C--------------------------------------------------------------------
            RESULT = XINF
         ELSE IF (X .LE. 1) THEN
C--------------------------------------------------------------------
C  XLEAST .LE.  ARG  .LE. 1.0
C--------------------------------------------------------------------
            IF (X .LT. XSMALL) THEN
C--------------------------------------------------------------------
C  Return for small ARG
C--------------------------------------------------------------------
                  RESULT = 1 / X
               ELSE
                  XX = X * X
                  SUMP = ((((P(1)*XX + P(2))*XX + P(3))*XX + P(4))*XX
     1                   + P(5))*XX + Q(3)
                  SUMQ = ((XX + Q(1))*XX + Q(2))*XX + Q(3)
                  SUMF = (((F(1)*XX + F(2))*XX + F(3))*XX + F(4))*XX
     1                   + F(5)
                  SUMG = ((XX + G(1))*XX + G(2))*XX + G(3)
                  RESULT = (XX * LOG(X) * SUMF/SUMG + SUMP/SUMQ) / X
                  IF (JINT .EQ. 2) RESULT = RESULT * EXP(X)
            END IF
         ELSE IF ((JINT .EQ. 1) .AND. (X .GT. XMAX)) THEN
C--------------------------------------------------------------------
C  Error return for  ARG  .GT. XMAX
C--------------------------------------------------------------------
            RESULT = 0
         ELSE
C--------------------------------------------------------------------
C  1.0 .LT.  ARG
C--------------------------------------------------------------------
            XX = 1 / X
            SUMP = PP(1)
            DO 120 I = 2, 11
               SUMP = SUMP * XX + PP(I)
  120       CONTINUE
            SUMQ = XX
            DO 140 I = 1, 8
               SUMQ = (SUMQ + QQ(I)) * XX
  140       CONTINUE
            SUMQ = SUMQ + QQ(9)
            RESULT = SUMP / SUMQ / SQRT(X)
            IF (JINT .EQ. 1) RESULT = RESULT * EXP(-X)
      END IF
      RETURN
C---------- Last line of CALCK1 ----------
      END SUBROUTINE CALCK1
CS    REAL
      DOUBLE PRECISION    FUNCTION BESK1(X)
C--------------------------------------------------------------------
C
C This function program computes approximate values for the
C   modified Bessel function of the second kind of order one
C   for arguments  XLEAST .LE. ARG .LE. XMAX.
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION   X, RESULT
C--------------------------------------------------------------------
      JINT = 1
      CALL CALCK1(X,RESULT,JINT)
      BESK1 = RESULT
      RETURN
C---------- Last line of BESK1 ----------
      END FUNCTION BESK1
CS    REAL
      DOUBLE PRECISION   FUNCTION BESEK1(X)
C--------------------------------------------------------------------
C
C This function program computes approximate values for the
C   modified Bessel function of the second kind of order one
C   multiplied by the exponential function, for arguments
C   XLEAST .LE. ARG .LE. XMAX.
C
C--------------------------------------------------------------------
      INTEGER JINT
CS    REAL
      DOUBLE PRECISION X, RESULT
C--------------------------------------------------------------------
      JINT = 2
      CALL CALCK1(X,RESULT,JINT)
      BESEK1 = RESULT
      RETURN
C---------- Last line of BESEK1 ----------
      END FUNCTION BESEK1

      end module k1
