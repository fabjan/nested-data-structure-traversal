type lesson  = {position: int option, name: string}
type section = {position: int option, title: string, resetLessonPosition: bool, lessons: lesson list}

fun mkSection title reset lessons = {position = NONE, title = title, resetLessonPosition = reset, lessons = lessons}
fun mkLesson name                 = {position = NONE, name = name}

fun updateSection pos lessons ({title, resetLessonPosition, ...} : section) =
    {position = SOME pos, lessons = lessons, title = title, resetLessonPosition = resetLessonPosition}
fun updateLesson pos ({name, ...} : lesson) =
    {position = SOME pos, name = name}

val sections : section list = [
    mkSection "Getting started" false [
        mkLesson "Welcome",
        mkLesson "Installation"
    ],
    mkSection "Basic operator" false [
        mkLesson "Addition / Subtraction",
        mkLesson "Multiplication / Division"
    ],
    mkSection "Advanced topics" true [
        mkLesson "Mutability",
        mkLesson "Immutability"
    ]
]

fun withPositions sections =
    let val (positioned, _, _) = List.foldl positionSection ([], 1, 1) sections in
        rev positioned
    end    

and positionSection (section as { title, resetLessonPosition, lessons, ... }, (sections, secPos, lessPos)) =
    let val lessPos' = if resetLessonPosition then 1 else lessPos
        val (lessons', lessPos'') = List.foldl positionLesson ([], lessPos') lessons in
        (updateSection secPos (rev lessons') section :: sections, secPos + 1, lessPos'')
    end

and positionLesson (lesson, (lessons, lessPos)) =
    (updateLesson lessPos lesson :: lessons, lessPos + 1)

val sections' = withPositions sections
