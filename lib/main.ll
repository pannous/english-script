; ModuleID = 'main.bc'

@0 = private unnamed_addr constant [12 x i8] c"hello world\00"

declare i32 @printf(i8*)

declare i8* @getenv(i8*)

define void @init() {
  %1 = call i32 @printf(i8* getelementptr inbounds ([12 x i8]* @0, i32 0, i32 0))
  ret void
}

define void @main() {
  call void @init()
  ret void
}
