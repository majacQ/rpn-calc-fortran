! main program for Fortran 2018 RPN calculator

!---- (historical notes) -----------
!  Programmer:   David G. Simpson
!                NASA Goddard Space Flight Center
!                Greenbelt, Maryland  20771
!  Date:         December 28, 2005
!-----------------------------------


PROGRAM RPN
use, intrinsic:: iso_fortran_env, only: stdout=>output_unit, stdin=>input_unit
USE GLOBAL
use funcs, only:  isrational, isreal, iscomplex, toUpper
use stackops, only: printx, push_stack
use evals, only: eval
IMPLICIT NONE

real(wp), PARAMETER :: PI = 4 * atan(1._wp)
real(wp), PARAMETER :: TWOPI = 2*pi
INTEGER :: IDX, IERR, DEL, PTR, RN, RD
real(wp) :: X
COMPLEX(wp) :: CX
CHARACTER(300) :: LINE, SUBSTR
CHARACTER(100) :: NUMSTR
LOGICAL :: NUM_FLAG = .false.


print *, 'Fortran 2018  RPN Calculator, Version '//VERSION

!     Initialize data.

call init_stack()

DEL = IACHAR('a') - IACHAR('A')                                               ! find ASCII position diff between 'A' and 'a'

STACK = 0                                                                 ! clear the REAL stack
REG = 0                                                                   ! clear the REAL registers
LASTX = 0                                                                 ! clear the REAL LAST X register

NN = 0                                                                    ! clear the REAL summation registers
SUMX = 0
SUMX2 = 0
SUMY = 0
SUMY2 = 0
SUMXY = 0

CSTACK = (0,0)                                                        ! clear the COMPLEX stack
CREG = (0,0)                                                          ! clear the COMPLEX registers
CLASTX = (0,0)                                                        ! clear the COMPLEX LAST X register

CNN = (0,0)                                                           ! clear the COMPLEX summation registers
CSUMX = (0,0)
CSUMX2 = (0,0)
CSUMY = (0,0)
CSUMY2 = (0,0)
CSUMXY = (0,0)

RNSTACK = 0; RDSTACK = 1                                                      ! clear the RATIONAL stack
RNREG = 0; RDREG = 1                                                          ! clear the RATIONAL registers
RNLASTX = 0; RDLASTX = 1                                                      ! clear the RATIONAL LAST X register

RNNN = 0; RDNN = 1                                                            ! clear the RATIONAL summation registers
RNSUMX = 0; RDSUMX = 1
RNSUMX2 = 0; RDSUMX2 = 1
RNSUMY = 0; RDSUMY = 1
RNSUMY2 = 0; RDSUMY2 = 1
RNSUMXY = 0; RDSUMXY = 1

ANGLE_MODE = INITIAL_ANGLE_MODE

SELECT CASE (ANGLE_MODE)
   CASE (1)                                                                   ! deg
      ANGLE_FACTOR = PI/180
   CASE (2)                                                                   ! rad
      ANGLE_FACTOR = 1
   CASE (3)                                                                   ! grad
      ANGLE_FACTOR = PI/200
   CASE (4)                                                                   ! rev
      ANGLE_FACTOR = TWOPI
END SELECT

DISP_MODE = INITIAL_DISP_MODE                                                 ! set modes
DISP_DIGITS = INITIAL_DISP_DIGITS
DOMAIN_MODE = INITIAL_DOMAIN_MODE
BASE_MODE = INITIAL_BASE_MODE
FRACTION_MODE = INITIAL_FRACTION_MODE

FRACTOL = INITIAL_FRACTOL                                                     ! set decimal-to-fraction tolerance

!     call random_init()   ! Fortran 2018 + the following line
CALL RANDOM_SEED()                                                           ! init random number generator

! -----  Main loop.

DO                                                                            ! loop once for each input line
   WRITE(stdout,'(A)', ADVANCE='NO') '  ? '
   READ (stdin,'(A132)', iostat=ierr) LINE
   if (ierr<0) exit  ! Ctrl D was pressed

!     Convert the input line to all uppercase, removing leftmost blanks

   LINE = toUpper(ADJUSTL(LINE))

!     Search for QUIT 'Q'

   IF (TRIM(LINE) == 'Q') exit

   PTR = 1

!     Loop for each element in the input line.

   DO
      IDX = INDEX(LINE(PTR:), ' ') + PTR - 1                                  ! look for the next space..
      IF (IDX .EQ. 0) IDX = LEN(LINE(PTR:))                                   ! ..or end of line
      SUBSTR = LINE(PTR:IDX-1)                                                ! get the current substring

      SELECT CASE (DOMAIN_MODE)
         CASE (1)
            NUM_FLAG = ISREAL(SUBSTR, X)                                     ! convert to a real number, if possible
         CASE (2)
            NUM_FLAG = ISCOMPLEX (SUBSTR, CX)                                 ! convert to a complex number, if possible
         CASE (3)
            NUM_FLAG = ISRATIONAL (SUBSTR, RN, RD)                            ! convert to a rational number, if possible
      END SELECT

      IF (NUM_FLAG) THEN                                                      ! if a number, then put it on the stack
         SELECT CASE (DOMAIN_MODE)
            CASE (1)
               CALL PUSH_STACK (X)                                            ! push real number onto real stack
            CASE (2)
               CALL push_stack(CX)                                          ! push complex number onto complex stack
            CASE (3)
               CALL push_stack(RN, RD)                                      ! push rational number onto rational stack
         END SELECT
      ELSE                                                                    ! else it's an operator
         CALL EVAL (SUBSTR)                                                   ! evaluate operator
      END IF

      PTR = IDX + 1                                                           ! update line pointer
      IF (LEN_TRIM(LINE(PTR:)) .EQ. 0) EXIT                                   ! exit if at end of line
   END DO


!     Print X register.

   SELECT CASE (DOMAIN_MODE)
      CASE (1)
         CALL PRINTX(STACK(1), NUMSTR)                                        ! format REAL X
      CASE (2)
         CALL PRINTX(CSTACK(1), NUMSTR)                                      ! format COMPLEX X
      CASE (3)
         CALL PRINTX(RNSTACK(1), RDSTACK(1), NUMSTR)                         ! format RATIONAL X
   END SELECT

   print '(3X,A)', TRIM(NUMSTR)                                  ! print X

END DO

! -- end program by printing last value (helping automatic self test cases)
print *,new_line('')
SELECT CASE (DOMAIN_MODE)
CASE (1)
  CALL PRINTX(STACK(1), NUMSTR)
CASE (2)
  CALL PRINTX(CSTACK(1), NUMSTR)
CASE (3)
  CALL PRINTX(RNSTACK(1), RDSTACK(1), NUMSTR)
END SELECT

print '(3X,A)', TRIM(NUMSTR)

END PROGRAM RPN
