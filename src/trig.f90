module trig

use assert, only: wp

implicit none

interface csc
  procedure csc_r, csc_c
end interface csc

interface acsc
  procedure acsc_r, acsc_c
end interface acsc

interface sec
  procedure sec_r, sec_c
end interface sec

interface asec
  procedure asec_r, asec_c
end interface asec

interface cot
  procedure cot_r, cot_c
end interface cot

interface acot
  procedure acot_r, acot_c
end interface acot

interface hav
  procedure hav_r, hav_c
end interface hav

interface ahav
  procedure ahav_r, ahav_c
end interface ahav

interface crd
  procedure crd_r, crd_c
end interface crd

contains


!***********************************************************************************************************************************
!  SEC
!
!  Secant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION SEC_r (X) RESULT (sec)
real(wp), INTENT (IN) :: X

sec = 1._wp/COS(X)
END FUNCTION SEC_r


elemental complex(wp) FUNCTION SEC_c(Z) result(sec)
COMPLEX(wp), INTENT(IN) :: Z

SEC = 1._wp/COS(Z)
END FUNCTION SEC_c



!***********************************************************************************************************************************
!  ASEC
!
!  Inverse secant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ASEC_r (Y) RESULT (X)
real(wp), INTENT (IN) :: Y

X = ACOS(1._wp/Y)
END FUNCTION ASEC_r


elemental complex(wp) FUNCTION ASEC_c (Z) RESULT (Y)
COMPLEX(wp), INTENT(IN) :: Z

Y = ACOS(1._wp/Z)
END FUNCTION ASEC_c
!***********************************************************************************************************************************
!  CSC
!
!  Cosecant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION CSC_r(X) result(csc)
real(wp), INTENT (IN) :: X

 CSC = 1._wp/SIN(X)
END FUNCTION CSC_r


elemental complex(wp) FUNCTION CSC_c(Z) result(csc)
COMPLEX(wp), INTENT(IN) :: Z

 CSC = 1._wp/SIN(Z)

END FUNCTION CSC_c


!***********************************************************************************************************************************
!  ACSC
!
!  Inverse cosecant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ACSC_r(Y) result(acsc)
real(wp), INTENT (IN) :: Y

ACSC = ASIN(1._wp/Y)
END FUNCTION ACSC_r


elemental complex(wp) FUNCTION ACSC_c(Z) RESULT(acsc)
COMPLEX(wp), INTENT(IN) :: Z

acsc = ASIN(1._wp/Z)

END FUNCTION ACSC_c


!***********************************************************************************************************************************
!  COT
!
!  Cotangent.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION COT_r(X) result(cot)
real(wp), INTENT (IN) :: X

 COT = 1._wp/TAN(X)
END FUNCTION COT_r


elemental complex(wp) FUNCTION COT_c(Z) result(cot)
COMPLEX(wp), INTENT(IN) :: Z

 COT = COS(Z)/SIN(Z)

END FUNCTION COT_c

!***********************************************************************************************************************************
!  ACOT
!
!  Inverse cotangent.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ACOT_r (Y) result(acot)
real(wp), INTENT (IN) :: Y

ACOT = ATAN(1._wp/Y)

END FUNCTION ACOT_r


elemental complex(wp) FUNCTION ACOT_c(Y) result (Acot)
complex(wp), INTENT (IN) :: Y

ACOT = ATAN(1._wp/Y)
END FUNCTION ACOT_c

!***********************************************************************************************************************************
!  ACOT2
!
!  Inverse cotangent (two arguments).
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ACOT2 (Y,Z) 

real(wp), INTENT (IN) :: Y                                           ! cotangent numerator
real(wp), INTENT (IN) :: Z                                           ! cotangent denominator

ACOT2 = ATAN2(Z,Y)

END FUNCTION ACOT2


!***********************************************************************************************************************************
!  EXSEC
!
!  Exsecant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION EXSEC (X)
real(wp), INTENT (IN) :: X
 
EXSEC = 1._wp/COS(X) - 1._wp

END FUNCTION EXSEC

!***********************************************************************************************************************************
!  CEXSEC
!
!  Complex exsecant.
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CEXSEC (Z)

COMPLEX(wp), INTENT(IN) :: Z
 cexsec = 1._wp/COS(Z) - 1._wp

END FUNCTION CEXSEC

!***********************************************************************************************************************************
!  AEXSEC
!
!  Inverse exsecant.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION AEXSEC (Y)
real(wp), INTENT (IN) :: Y

AEXSEC = ACOS(1._wp / (Y + 1._wp))

END FUNCTION AEXSEC

!***********************************************************************************************************************************
!  CAEXSEC
!
!  Complex inverse exsecant.
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CAEXSEC (Y) RESULT (X)

COMPLEX(wp), INTENT (IN) :: Y

X = ACOS(1._wp / (Y + 1._wp))

END FUNCTION CAEXSEC


!***********************************************************************************************************************************
!  VERS
!
!  Versine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION VERS (X) 
real(wp), INTENT (IN) :: X

VERS = 1._wp - COS(X)

END FUNCTION VERS

!***********************************************************************************************************************************
!  CVERS
!
!  Complex versine.
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CVERS (Z)
COMPLEX(wp), INTENT(IN) :: Z

 CVERS = 1._wp - COS(Z)

END FUNCTION CVERS

!***********************************************************************************************************************************
!  AVERS
!
!  Inverse versine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION AVERS (Y)
real(wp), INTENT (IN) :: Y

AVERS = ACOS(1._wp - Y)

END FUNCTION AVERS

!***********************************************************************************************************************************
!  CAVERS
!
!  Complex inverse versine.
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CAVERS (Y) RESULT (X)

COMPLEX(wp), INTENT (IN) :: Y

X = acos(1._wp - Y)

END FUNCTION CAVERS


!*************************************************************************************************
!  COVERS
!
!  Coversine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION COVERS (X) RESULT (Y)

real(wp), INTENT (IN) :: X

Y = 1._wp - SIN(X)

END FUNCTION COVERS


!***********************************************************************************************************************************
!  CCOVERS
!
!  Complex coversine.
!***********************************************************************************************************************************

FUNCTION CCOVERS (Z) RESULT (Y)

COMPLEX(wp), INTENT(IN) :: Z
COMPLEX(wp) :: Y

Y = 1._wp - SIN(Z)

END FUNCTION CCOVERS





!***********************************************************************************************************************************
!  ACOVERS
!
!  Inverse coversine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ACOVERS (Y) RESULT (X)
real(wp), INTENT (IN) :: Y

X = ASIN(1._wp - Y)
END FUNCTION ACOVERS





!***********************************************************************************************************************************
!  CACOVERS
!
!  Complex inverse coversine.
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CACOVERS (Y) RESULT (X)
COMPLEX(wp), INTENT (IN) :: Y

X = ASIN(1._wp - Y)
END FUNCTION CACOVERS


!***********************************************************************************************************************************
!  HAV
!
!  Haversine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION HAV_r(X) RESULT (Y)
real(wp), INTENT (IN) :: X

Y = (SIN(0.5_wp*X))**2
END FUNCTION HAV_r


elemental complex(wp) FUNCTION HAV_c(Z) RESULT (Y)
COMPLEX(wp), INTENT(IN) :: Z

Y = (SIN(0.5_wp*Z))**2
END FUNCTION HAV_c



!***********************************************************************************************************************************
!  AHAV
!
!  Inverse haversine.
!***********************************************************************************************************************************

elemental real(wp) FUNCTION AHAV_r(Y) RESULT (X)

real(wp), INTENT (IN) :: Y

X = 2._wp*ASIN(SQRT(Y))
END FUNCTION AHAV_r


elemental complex(wp) FUNCTION AHAV_c(Y) RESULT (X)
COMPLEX(wp), INTENT (IN) :: Y

X = 2._wp*asin(SQRT(Y))
END FUNCTION AHAV_c


!***********************************************************************************************************************************
!  CRD
!
!  Chord (of Ptolemy).
!***********************************************************************************************************************************

elemental real(wp) FUNCTION CRD_r (X) result(crd)
real(wp), INTENT (IN) :: X

 CRD = 2._wp*SIN(0.5_wp*X)

END FUNCTION CRD_r


elemental complex(wp) FUNCTION CRD_c (Z) RESULT (crd)
COMPLEX(wp), INTENT(IN) :: Z

 CRD = 2._wp*SIN(0.5_wp*Z)

END FUNCTION CRD_c



!***********************************************************************************************************************************
!  ACRD
!
!  Inverse chord (of Ptolemy).
!***********************************************************************************************************************************

elemental real(wp) FUNCTION ACRD (Y) RESULT (X)

real(wp), INTENT (IN) :: Y

X = 2.0D0*ASIN(0.5D0*Y)

END FUNCTION ACRD
!***********************************************************************************************************************************
!  CACRD
!
!  Complex inverse chord (of Ptolemy).
!***********************************************************************************************************************************

elemental complex(wp) FUNCTION CACRD (Y) RESULT (X)

COMPLEX(wp), INTENT (IN) :: Y

X = 2.0D0*asin(0.5D0*Y)

END FUNCTION CACRD


end module trig
