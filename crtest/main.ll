; ModuleID = 'main_module'
source_filename = "main_module"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "arm-none-unknown-eabi"

%Nil = type {}
%String = type { i32, i32, i32, i8 }
%"union.GBA::Screen::HAL::Vram" = type { [24000 x i32] }
%"struct.GBA::Screen::HAL::Palette" = type { [256 x i16], [256 x i16] }

@ARGC_UNSAFE = internal global i32 0
@ARGV_UNSAFE = internal global i8** null
@"Crystal::BUILD_COMMIT" = internal global %Nil zeroinitializer
@"Crystal::BUILD_DATE" = internal global %String* null
@"'2023-03-07'" = private constant { i32, i32, i32, [11 x i8] } { i32 1, i32 10, i32 10, [11 x i8] c"2023-03-07\00" }
@"Crystal::CACHE_DIR" = internal global %String* null
@"'/home/globoplox/.ca...'" = private constant { i32, i32, i32, [31 x i8] } { i32 1, i32 30, i32 30, [31 x i8] c"/home/globoplox/.cache/crystal\00" }
@"Crystal::DEFAULT_PATH" = internal global %String* null
@"'lib:/usr/lib/crysta...'" = private constant { i32, i32, i32, [21 x i8] } { i32 1, i32 20, i32 20, [21 x i8] c"lib:/usr/lib/crystal\00" }
@"Crystal::DESCRIPTION" = internal global %String* null
@"'Crystal 1.7.3 (2023...'" = private constant { i32, i32, i32, [77 x i8] } { i32 1, i32 76, i32 76, [77 x i8] c"Crystal 1.7.3 (2023-03-07)\0A\0ALLVM: 14.0.6\0ADefault target: x86_64-pc-linux-gnu\00" }
@"Crystal::PATH" = internal global %String* null
@"Crystal::LIBRARY_PATH" = internal global %String* null
@"'/usr/bin/../lib/cry...'" = private constant { i32, i32, i32, [24 x i8] } { i32 1, i32 23, i32 23, [24 x i8] c"/usr/bin/../lib/crystal\00" }
@"Crystal::VERSION" = internal global %String* null
@"'1.7.3'" = private constant { i32, i32, i32, [6 x i8] } { i32 1, i32 5, i32 5, [6 x i8] c"1.7.3\00" }
@"Crystal::LLVM_VERSION" = internal global %String* null
@"'14.0.6'" = private constant { i32, i32, i32, [7 x i8] } { i32 1, i32 6, i32 6, [7 x i8] c"14.0.6\00" }
@"GBA::Screen::Mode4::page_offset" = internal global i32 0
@DISPCNT = external global i16
@VRAM = external global %"union.GBA::Screen::HAL::Vram"
@PALETTE = external global %"struct.GBA::Screen::HAL::Palette"

define void @__crystal_main(i32 %argc, i8** %argv) !dbg !3 {
alloca:
  %0 = alloca %"struct.GBA::Screen::HAL::Palette", align 4, !dbg !9
  %1 = alloca %"struct.GBA::Screen::HAL::Palette", align 4, !dbg !12
  br label %entry

entry:                                            ; preds = %alloca
  store i32 %argc, i32* @ARGC_UNSAFE, align 4, !dbg !13
  store i8** %argv, i8*** @ARGV_UNSAFE, align 4, !dbg !13
  store %Nil zeroinitializer, %Nil* @"Crystal::BUILD_COMMIT", align 1, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [11 x i8] }* @"'2023-03-07'" to %String*), %String** @"Crystal::BUILD_DATE", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [31 x i8] }* @"'/home/globoplox/.ca...'" to %String*), %String** @"Crystal::CACHE_DIR", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [21 x i8] }* @"'lib:/usr/lib/crysta...'" to %String*), %String** @"Crystal::DEFAULT_PATH", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [77 x i8] }* @"'Crystal 1.7.3 (2023...'" to %String*), %String** @"Crystal::DESCRIPTION", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [21 x i8] }* @"'lib:/usr/lib/crysta...'" to %String*), %String** @"Crystal::PATH", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [24 x i8] }* @"'/usr/bin/../lib/cry...'" to %String*), %String** @"Crystal::LIBRARY_PATH", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [6 x i8] }* @"'1.7.3'" to %String*), %String** @"Crystal::VERSION", align 4, !dbg !13
  store %String* bitcast ({ i32, i32, i32, [7 x i8] }* @"'14.0.6'" to %String*), %String** @"Crystal::LLVM_VERSION", align 4, !dbg !13
  %2 = call i16 @"*GBA::Screen::Mode3@GBA::Screen::Mode3::init:UInt16"(), !dbg !15
  %3 = call i16 @"*GBA::Screen::Mode3@GBA::Screen::Mode3::[]=<Int32, Int32, UInt16>:UInt16"(i32 0, i32 0, i16 -1), !dbg !16
  %4 = call i16 @"*GBA::Screen::Mode3@GBA::Screen::Mode3::[]=<Int32, Int32, UInt16>:UInt16"(i32 1, i32 0, i16 -1), !dbg !9
  %5 = call i16 @"*StaticArray(UInt16, 256)@StaticArray(T, N)#[]=<Int32, UInt16>:UInt16"([256 x i16]* getelementptr inbounds (%"struct.GBA::Screen::HAL::Palette", %"struct.GBA::Screen::HAL::Palette"* @PALETTE, i32 0, i32 0), i32 255, i16 31), !dbg !12
  %6 = call i16 @"*StaticArray(UInt16, 256)@StaticArray(T, N)#[]=<Int32, UInt16>:UInt16"([256 x i16]* getelementptr inbounds (%"struct.GBA::Screen::HAL::Palette", %"struct.GBA::Screen::HAL::Palette"* @PALETTE, i32 0, i32 0), i32 170, i16 992), !dbg !17
  %7 = call i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::init:UInt16"(), !dbg !18
  %8 = call i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::[]=<Int32, Int32, UInt8>:UInt16"(i32 1, i32 0, i8 -86), !dbg !19
  %9 = call i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::[]=<Int32, Int32, UInt8>:UInt16"(i32 2, i32 0, i8 -86), !dbg !20
  %10 = call i32 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::flip:UInt32"(), !dbg !21
  %11 = call i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::[]=<Int32, Int32, UInt8>:UInt16"(i32 1, i32 0, i8 -86), !dbg !22
  %12 = call i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::[]=<Int32, Int32, UInt8>:UInt16"(i32 2, i32 0, i8 -86), !dbg !23
  br label %while, !dbg !23

while:                                            ; preds = %while, %entry
  br label %while, !dbg !23
}

declare i32 @printf(i8*, ...)

; Function Attrs: uwtable
define i32 @main(i32 %argc, i8** %argv) #0 !dbg !24 {
entry:
  call void @__crystal_main(i32 %argc, i8** %argv), !dbg !26
  ret i32 0, !dbg !26
}

; Function Attrs: uwtable
define internal i16 @"*GBA::Screen::Mode3@GBA::Screen::Mode3::init:UInt16"() #0 !dbg !27 {
entry:
  store i16 1027, i16* @DISPCNT, align 2, !dbg !28
  ret i16 1027, !dbg !28
}

; Function Attrs: uwtable
define internal i16 @"*GBA::Screen::Mode3@GBA::Screen::Mode3::[]=<Int32, Int32, UInt16>:UInt16"(i32 %x, i32 %y, i16 %color) #0 !dbg !29 {
alloca:
  %0 = alloca %"union.GBA::Screen::HAL::Vram", align 4, !dbg !30
  br label %entry

entry:                                            ; preds = %alloca
  %1 = mul i32 %y, 240, !dbg !30
  %2 = add i32 %1, %x, !dbg !30
  %3 = call i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]=<Int32, UInt16>:UInt16"([48000 x i16]* bitcast (%"union.GBA::Screen::HAL::Vram"* @VRAM to [48000 x i16]*), i32 %2, i16 %color), !dbg !31
  ret i16 %3, !dbg !31
}

; Function Attrs: uwtable
define internal i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]=<Int32, UInt16>:UInt16"([48000 x i16]* %self, i32 %index, i16 %value) #0 !dbg !32 {
entry:
  %0 = getelementptr inbounds [48000 x i16], [48000 x i16]* %self, i32 0, i32 0, !dbg !33
  %1 = sext i32 %index to i64, !dbg !33
  %2 = getelementptr inbounds i16, i16* %0, i64 %1, !dbg !33
  store i16 %value, i16* %2, align 2, !dbg !33
  ret i16 %value, !dbg !33
}

; Function Attrs: uwtable
define internal i16 @"*StaticArray(UInt16, 256)@StaticArray(T, N)#[]=<Int32, UInt16>:UInt16"([256 x i16]* %self, i32 %index, i16 %value) #0 !dbg !34 {
entry:
  %0 = getelementptr inbounds [256 x i16], [256 x i16]* %self, i32 0, i32 0, !dbg !35
  %1 = sext i32 %index to i64, !dbg !35
  %2 = getelementptr inbounds i16, i16* %0, i64 %1, !dbg !35
  store i16 %value, i16* %2, align 2, !dbg !35
  ret i16 %value, !dbg !35
}

; Function Attrs: uwtable
define internal i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::init:UInt16"() #0 !dbg !36 {
entry:
  store i16 1028, i16* @DISPCNT, align 2, !dbg !37
  ret i16 1028, !dbg !37
}

; Function Attrs: uwtable
define internal i16 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::[]=<Int32, Int32, UInt8>:UInt16"(i32 %x, i32 %y, i8 %palette_index) #0 !dbg !38 {
alloca:
  %i = alloca i32, align 4, !dbg !39
  %px = alloca i16, align 2, !dbg !39
  %0 = alloca %"union.GBA::Screen::HAL::Vram", align 4, !dbg !40
  %1 = alloca %"union.GBA::Screen::HAL::Vram", align 4, !dbg !41
  br label %entry

entry:                                            ; preds = %alloca
  %2 = load i32, i32* @"GBA::Screen::Mode4::page_offset", align 4, !dbg !42
  %3 = mul i32 %y, 240, !dbg !42
  %4 = add i32 %2, %3, !dbg !42
  %5 = add i32 %4, %x, !dbg !42
  %6 = call i32 @"*UInt32@Int#>><Int32>:UInt32"(i32 %5, i32 1), !dbg !43
  store i32 %6, i32* %i, align 4, !dbg !40
  %7 = load i32, i32* %i, align 4, !dbg !40
  %8 = call i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]<UInt32>:UInt16"([48000 x i16]* bitcast (%"union.GBA::Screen::HAL::Vram"* @VRAM to [48000 x i16]*), i32 %7), !dbg !44
  store i16 %8, i16* %px, align 2, !dbg !45
  %9 = and i32 %x, 1, !dbg !46
  %10 = icmp eq i32 %9, 0, !dbg !46
  br i1 %10, label %then, label %else, !dbg !46

then:                                             ; preds = %entry
  %11 = load i16, i16* %px, align 2, !dbg !46
  %12 = zext i16 %11 to i32, !dbg !46
  %13 = and i32 %12, 65280, !dbg !46
  %14 = trunc i32 %13 to i16, !dbg !46
  %15 = zext i8 %palette_index to i16, !dbg !46
  %16 = or i16 %14, %15, !dbg !46
  store i16 %16, i16* %px, align 2, !dbg !47
  br label %exit, !dbg !47

else:                                             ; preds = %entry
  %17 = load i16, i16* %px, align 2, !dbg !47
  %18 = zext i16 %17 to i32, !dbg !47
  %19 = and i32 %18, 255, !dbg !47
  %20 = trunc i32 %19 to i16, !dbg !47
  %21 = zext i8 %palette_index to i16, !dbg !47
  %22 = call i16 @"*UInt16@Int#<<<Int32>:UInt16"(i16 %21, i32 8), !dbg !48
  %23 = or i16 %20, %22, !dbg !48
  store i16 %23, i16* %px, align 2, !dbg !41
  br label %exit, !dbg !41

exit:                                             ; preds = %else, %then
  %24 = load i32, i32* %i, align 4, !dbg !41
  %25 = load i16, i16* %px, align 2, !dbg !41
  %26 = call i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]=<UInt32, UInt16>:UInt16"([48000 x i16]* bitcast (%"union.GBA::Screen::HAL::Vram"* @VRAM to [48000 x i16]*), i32 %24, i16 %25), !dbg !49
  ret i16 %26, !dbg !49
}

; Function Attrs: uwtable
define internal i32 @"*UInt32@Int#>><Int32>:UInt32"(i32 %self, i32 %other) #0 !dbg !50 {
entry:
  %0 = lshr i32 %self, %other, !dbg !51
  ret i32 %0, !dbg !51
}

; Function Attrs: uwtable
define internal i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]<UInt32>:UInt16"([48000 x i16]* %self, i32 %index) #0 !dbg !52 {
entry:
  %0 = getelementptr inbounds [48000 x i16], [48000 x i16]* %self, i32 0, i32 0, !dbg !53
  %1 = zext i32 %index to i64, !dbg !53
  %2 = getelementptr inbounds i16, i16* %0, i64 %1, !dbg !53
  %3 = load i16, i16* %2, align 2, !dbg !53
  ret i16 %3, !dbg !53
}

; Function Attrs: uwtable
define internal i16 @"*UInt16@Int#<<<Int32>:UInt16"(i16 %self, i32 %other) #0 !dbg !54 {
entry:
  %0 = zext i16 %self to i32, !dbg !55
  %1 = shl i32 %0, %other, !dbg !55
  %2 = trunc i32 %1 to i16, !dbg !55
  ret i16 %2, !dbg !55
}

; Function Attrs: uwtable
define internal i16 @"*StaticArray(UInt16, 48000)@StaticArray(T, N)#[]=<UInt32, UInt16>:UInt16"([48000 x i16]* %self, i32 %index, i16 %value) #0 !dbg !56 {
entry:
  %0 = getelementptr inbounds [48000 x i16], [48000 x i16]* %self, i32 0, i32 0, !dbg !57
  %1 = zext i32 %index to i64, !dbg !57
  %2 = getelementptr inbounds i16, i16* %0, i64 %1, !dbg !57
  store i16 %value, i16* %2, align 2, !dbg !57
  ret i16 %value, !dbg !57
}

; Function Attrs: uwtable
define internal i32 @"*GBA::Screen::Mode4@GBA::Screen::Mode4::flip:UInt32"() #0 !dbg !58 {
alloca:
  %__temp_1 = alloca i32, align 4, !dbg !59
  br label %entry

entry:                                            ; preds = %alloca
  store i32 90, i32* %__temp_1, align 4, !dbg !60
  %0 = load i16, i16* @DISPCNT, align 2, !dbg !60
  %1 = xor i16 %0, 16, !dbg !60
  store i16 %1, i16* @DISPCNT, align 2, !dbg !60
  %2 = load i32, i32* @"GBA::Screen::Mode4::page_offset", align 4, !dbg !61
  %3 = xor i32 %2, 40960, !dbg !61
  store i32 %3, i32* @"GBA::Screen::Mode4::page_offset", align 4, !dbg !61
  ret i32 %3, !dbg !61
}

attributes #0 = { uwtable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "Crystal", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "main_module", directory: ".")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "__crystal_main", linkageName: "__crystal_main", scope: !4, file: !4, type: !5, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !8)
!4 = !DIFile(filename: "??", directory: ".")
!5 = !DISubroutineType(types: !6)
!6 = !{!7}
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{}
!9 = !DILocation(line: 97, column: 1, scope: !10)
!10 = distinct !DILexicalBlock(scope: !3, file: !11, line: 1, column: 1)
!11 = !DIFile(filename: "main.cr", directory: "/home/globoplox/gba-stuff/crtest")
!12 = !DILocation(line: 98, column: 1, scope: !10)
!13 = !DILocation(line: 0, scope: !14)
!14 = distinct !DILexicalBlock(scope: !3, file: !4, line: 1, column: 1)
!15 = !DILocation(line: 95, column: 1, scope: !10)
!16 = !DILocation(line: 96, column: 1, scope: !10)
!17 = !DILocation(line: 99, column: 1, scope: !10)
!18 = !DILocation(line: 100, column: 1, scope: !10)
!19 = !DILocation(line: 101, column: 1, scope: !10)
!20 = !DILocation(line: 102, column: 1, scope: !10)
!21 = !DILocation(line: 103, column: 1, scope: !10)
!22 = !DILocation(line: 104, column: 1, scope: !10)
!23 = !DILocation(line: 105, column: 1, scope: !10)
!24 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !25, file: !25, line: 11, type: !5, scopeLine: 11, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!25 = !DIFile(filename: "empty.cr", directory: "/usr/lib/crystal")
!26 = !DILocation(line: 12, column: 3, scope: !24)
!27 = distinct !DISubprogram(name: "init", linkageName: "init", scope: !11, file: !11, line: 52, type: !5, scopeLine: 52, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!28 = !DILocation(line: 52, column: 5, scope: !27)
!29 = distinct !DISubprogram(name: "[]=", linkageName: "[]=", scope: !11, file: !11, line: 59, type: !5, scopeLine: 59, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!30 = !DILocation(line: 59, column: 5, scope: !29)
!31 = !DILocation(line: 60, column: 7, scope: !29)
!32 = distinct !DISubprogram(name: "[]=", linkageName: "[]=", scope: !11, file: !11, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!33 = !DILocation(line: 2, column: 3, scope: !32)
!34 = distinct !DISubprogram(name: "[]=", linkageName: "[]=", scope: !11, file: !11, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!35 = !DILocation(line: 2, column: 3, scope: !34)
!36 = distinct !DISubprogram(name: "init", linkageName: "init", scope: !11, file: !11, line: 69, type: !5, scopeLine: 69, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!37 = !DILocation(line: 69, column: 5, scope: !36)
!38 = distinct !DISubprogram(name: "[]=", linkageName: "[]=", scope: !11, file: !11, line: 81, type: !5, scopeLine: 81, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!39 = !DILocation(line: 81, column: 5, scope: !38)
!40 = !DILocation(line: 82, column: 7, scope: !38)
!41 = !DILocation(line: 87, column: 8, scope: !38)
!42 = !DILocation(line: 82, column: 12, scope: !38)
!43 = !DILocation(line: 82, column: 11, scope: !38)
!44 = !DILocation(line: 83, column: 12, scope: !38)
!45 = !DILocation(line: 83, column: 7, scope: !38)
!46 = !DILocation(line: 84, column: 7, scope: !38)
!47 = !DILocation(line: 85, column: 8, scope: !38)
!48 = !DILocation(line: 87, column: 28, scope: !38)
!49 = !DILocation(line: 89, column: 7, scope: !38)
!50 = distinct !DISubprogram(name: ">>", linkageName: ">>", scope: !11, file: !11, line: 16, type: !5, scopeLine: 16, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!51 = !DILocation(line: 16, column: 3, scope: !50)
!52 = distinct !DISubprogram(name: "[]", linkageName: "[]", scope: !11, file: !11, line: 6, type: !5, scopeLine: 6, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!53 = !DILocation(line: 6, column: 3, scope: !52)
!54 = distinct !DISubprogram(name: "<<", linkageName: "<<", scope: !11, file: !11, line: 12, type: !5, scopeLine: 12, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!55 = !DILocation(line: 12, column: 3, scope: !54)
!56 = distinct !DISubprogram(name: "[]=", linkageName: "[]=", scope: !11, file: !11, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!57 = !DILocation(line: 2, column: 3, scope: !56)
!58 = distinct !DISubprogram(name: "flip", linkageName: "flip", scope: !11, file: !11, line: 76, type: !5, scopeLine: 76, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!59 = !DILocation(line: 76, column: 5, scope: !58)
!60 = !DILocation(line: 77, column: 7, scope: !58)
!61 = !DILocation(line: 78, column: 7, scope: !58)
