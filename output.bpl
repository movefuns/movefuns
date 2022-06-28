
// ** Expanded prelude

// Copyright (c) The Diem Core Contributors
// SPDX-License-Identifier: Apache-2.0

// Basic theory for vectors using arrays. This version of vectors is not extensional.

type {:datatype} Vec _;

function {:constructor} Vec<T>(v: [int]T, l: int): Vec T;

function {:builtin "MapConst"} MapConstVec<T>(T): [int]T;
function DefaultVecElem<T>(): T;
function {:inline} DefaultVecMap<T>(): [int]T { MapConstVec(DefaultVecElem()) }

function {:inline} EmptyVec<T>(): Vec T {
    Vec(DefaultVecMap(), 0)
}

function {:inline} MakeVec1<T>(v: T): Vec T {
    Vec(DefaultVecMap()[0 := v], 1)
}

function {:inline} MakeVec2<T>(v1: T, v2: T): Vec T {
    Vec(DefaultVecMap()[0 := v1][1 := v2], 2)
}

function {:inline} MakeVec3<T>(v1: T, v2: T, v3: T): Vec T {
    Vec(DefaultVecMap()[0 := v1][1 := v2][2 := v3], 3)
}

function {:inline} MakeVec4<T>(v1: T, v2: T, v3: T, v4: T): Vec T {
    Vec(DefaultVecMap()[0 := v1][1 := v2][2 := v3][3 := v4], 4)
}

function {:inline} ExtendVec<T>(v: Vec T, elem: T): Vec T {
    (var l := l#Vec(v);
    Vec(v#Vec(v)[l := elem], l + 1))
}

function {:inline} ReadVec<T>(v: Vec T, i: int): T {
    v#Vec(v)[i]
}

function {:inline} LenVec<T>(v: Vec T): int {
    l#Vec(v)
}

function {:inline} IsEmptyVec<T>(v: Vec T): bool {
    l#Vec(v) == 0
}

function {:inline} RemoveVec<T>(v: Vec T): Vec T {
    (var l := l#Vec(v) - 1;
    Vec(v#Vec(v)[l := DefaultVecElem()], l))
}

function {:inline} RemoveAtVec<T>(v: Vec T, i: int): Vec T {
    (var l := l#Vec(v) - 1;
    Vec(
        (lambda j: int ::
           if j >= 0 && j < l then
               if j < i then v#Vec(v)[j] else v#Vec(v)[j+1]
           else DefaultVecElem()),
        l))
}

function {:inline} ConcatVec<T>(v1: Vec T, v2: Vec T): Vec T {
    (var l1, m1, l2, m2 := l#Vec(v1), v#Vec(v1), l#Vec(v2), v#Vec(v2);
    Vec(
        (lambda i: int ::
          if i >= 0 && i < l1 + l2 then
            if i < l1 then m1[i] else m2[i - l1]
          else DefaultVecElem()),
        l1 + l2))
}

function {:inline} ReverseVec<T>(v: Vec T): Vec T {
    (var l := l#Vec(v);
    Vec(
        (lambda i: int :: if 0 <= i && i < l then v#Vec(v)[l - i - 1] else DefaultVecElem()),
        l))
}

function {:inline} SliceVec<T>(v: Vec T, i: int, j: int): Vec T {
    (var m := v#Vec(v);
    Vec(
        (lambda k:int ::
          if 0 <= k && k < j - i then
            m[i + k]
          else
            DefaultVecElem()),
        (if j - i < 0 then 0 else j - i)))
}


function {:inline} UpdateVec<T>(v: Vec T, i: int, elem: T): Vec T {
    Vec(v#Vec(v)[i := elem], l#Vec(v))
}

function {:inline} SwapVec<T>(v: Vec T, i: int, j: int): Vec T {
    (var m := v#Vec(v);
    Vec(m[i := m[j]][j := m[i]], l#Vec(v)))
}

function {:inline} ContainsVec<T>(v: Vec T, e: T): bool {
    (var l := l#Vec(v);
    (exists i: int :: InRangeVec(v, i) && v#Vec(v)[i] == e))
}

function IndexOfVec<T>(v: Vec T, e: T): int;
axiom {:ctor "Vec"} (forall<T> v: Vec T, e: T :: {IndexOfVec(v, e)}
    (var i := IndexOfVec(v,e);
     if (!ContainsVec(v, e)) then i == -1
     else InRangeVec(v, i) && ReadVec(v, i) == e &&
        (forall j: int :: j >= 0 && j < i ==> ReadVec(v, j) != e)));

// This function should stay non-inlined as it guards many quantifiers
// over vectors. It appears important to have this uninterpreted for
// quantifier triggering.
function InRangeVec<T>(v: Vec T, i: int): bool {
    i >= 0 && i < LenVec(v)
}

// Copyright (c) The Diem Core Contributors
// SPDX-License-Identifier: Apache-2.0

// Boogie model for multisets, based on Boogie arrays. This theory assumes extensional equality for element types.

type {:datatype} Multiset _;
function {:constructor} Multiset<T>(v: [T]int, l: int): Multiset T;

function {:builtin "MapConst"} MapConstMultiset<T>(l: int): [T]int;

function {:inline} EmptyMultiset<T>(): Multiset T {
    Multiset(MapConstMultiset(0), 0)
}

function {:inline} LenMultiset<T>(s: Multiset T): int {
    l#Multiset(s)
}

function {:inline} ExtendMultiset<T>(s: Multiset T, v: T): Multiset T {
    (var len := l#Multiset(s);
    (var cnt := v#Multiset(s)[v];
    Multiset(v#Multiset(s)[v := (cnt + 1)], len + 1)))
}

// This function returns (s1 - s2). This function assumes that s2 is a subset of s1.
function {:inline} SubtractMultiset<T>(s1: Multiset T, s2: Multiset T): Multiset T {
    (var len1 := l#Multiset(s1);
    (var len2 := l#Multiset(s2);
    Multiset((lambda v:T :: v#Multiset(s1)[v]-v#Multiset(s2)[v]), len1-len2)))
}

function {:inline} IsEmptyMultiset<T>(s: Multiset T): bool {
    (l#Multiset(s) == 0) &&
    (forall v: T :: v#Multiset(s)[v] == 0)
}

function {:inline} IsSubsetMultiset<T>(s1: Multiset T, s2: Multiset T): bool {
    (l#Multiset(s1) <= l#Multiset(s2)) &&
    (forall v: T :: v#Multiset(s1)[v] <= v#Multiset(s2)[v])
}

function {:inline} ContainsMultiset<T>(s: Multiset T, v: T): bool {
    v#Multiset(s)[v] > 0
}



// ============================================================================================
// Primitive Types

const $MAX_U8: int;
axiom $MAX_U8 == 255;
const $MAX_U64: int;
axiom $MAX_U64 == 18446744073709551615;
const $MAX_U128: int;
axiom $MAX_U128 == 340282366920938463463374607431768211455;

type {:datatype} $Range;
function {:constructor} $Range(lb: int, ub: int): $Range;

function {:inline} $IsValid'bool'(v: bool): bool {
  true
}

function $IsValid'u8'(v: int): bool {
  v >= 0 && v <= $MAX_U8
}

function $IsValid'u64'(v: int): bool {
  v >= 0 && v <= $MAX_U64
}

function $IsValid'u128'(v: int): bool {
  v >= 0 && v <= $MAX_U128
}

function $IsValid'num'(v: int): bool {
  true
}

function $IsValid'address'(v: int): bool {
  // TODO: restrict max to representable addresses?
  v >= 0
}

function {:inline} $IsValidRange(r: $Range): bool {
   $IsValid'u64'(lb#$Range(r)) &&  $IsValid'u64'(ub#$Range(r))
}

// Intentionally not inlined so it serves as a trigger in quantifiers.
function $InRange(r: $Range, i: int): bool {
   lb#$Range(r) <= i && i < ub#$Range(r)
}


function {:inline} $IsEqual'u8'(x: int, y: int): bool {
    x == y
}

function {:inline} $IsEqual'u64'(x: int, y: int): bool {
    x == y
}

function {:inline} $IsEqual'u128'(x: int, y: int): bool {
    x == y
}

function {:inline} $IsEqual'num'(x: int, y: int): bool {
    x == y
}

function {:inline} $IsEqual'address'(x: int, y: int): bool {
    x == y
}

function {:inline} $IsEqual'bool'(x: bool, y: bool): bool {
    x == y
}

// ============================================================================================
// Memory

type {:datatype} $Location;

// A global resource location within the statically known resource type's memory,
// where `a` is an address.
function {:constructor} $Global(a: int): $Location;

// A local location. `i` is the unique index of the local.
function {:constructor} $Local(i: int): $Location;

// The location of a reference outside of the verification scope, for example, a `&mut` parameter
// of the function being verified. References with these locations don't need to be written back
// when mutation ends.
function {:constructor} $Param(i: int): $Location;


// A mutable reference which also carries its current value. Since mutable references
// are single threaded in Move, we can keep them together and treat them as a value
// during mutation until the point they are stored back to their original location.
type {:datatype} $Mutation _;
function {:constructor} $Mutation<T>(l: $Location, p: Vec int, v: T): $Mutation T;

// Representation of memory for a given type.
type {:datatype} $Memory _;
function {:constructor} $Memory<T>(domain: [int]bool, contents: [int]T): $Memory T;

function {:builtin "MapConst"} $ConstMemoryDomain(v: bool): [int]bool;
function {:builtin "MapConst"} $ConstMemoryContent<T>(v: T): [int]T;
axiom $ConstMemoryDomain(false) == (lambda i: int :: false);
axiom $ConstMemoryDomain(true) == (lambda i: int :: true);


// Dereferences a mutation.
function {:inline} $Dereference<T>(ref: $Mutation T): T {
    v#$Mutation(ref)
}

// Update the value of a mutation.
function {:inline} $UpdateMutation<T>(m: $Mutation T, v: T): $Mutation T {
    $Mutation(l#$Mutation(m), p#$Mutation(m), v)
}

function {:inline} $ChildMutation<T1, T2>(m: $Mutation T1, offset: int, v: T2): $Mutation T2 {
    $Mutation(l#$Mutation(m), ExtendVec(p#$Mutation(m), offset), v)
}

// Return true of the mutation is a parent of a child which was derived with the given edge offset. This
// is used to implement write-back choices.
function {:inline} $IsParentMutation<T1, T2>(parent: $Mutation T1, edge: int, child: $Mutation T2 ): bool {
    l#$Mutation(parent) == l#$Mutation(child) &&
    (var pp := p#$Mutation(parent);
    (var cp := p#$Mutation(child);
    (var pl := LenVec(pp);
    (var cl := LenVec(cp);
     cl == pl + 1 &&
     (forall i: int:: i >= 0 && i < pl ==> ReadVec(pp, i) ==  ReadVec(cp, i)) &&
     $EdgeMatches(ReadVec(cp, pl), edge)
    ))))
}

// Return true of the mutation is a parent of a child, for hyper edge.
function {:inline} $IsParentMutationHyper<T1, T2>(parent: $Mutation T1, hyper_edge: Vec int, child: $Mutation T2 ): bool {
    l#$Mutation(parent) == l#$Mutation(child) &&
    (var pp := p#$Mutation(parent);
    (var cp := p#$Mutation(child);
    (var pl := LenVec(pp);
    (var cl := LenVec(cp);
    (var el := LenVec(hyper_edge);
     cl == pl + el &&
     (forall i: int:: i >= 0 && i < pl ==> ReadVec(pp, i) == ReadVec(cp, i)) &&
     (forall i: int:: i >= 0 && i < el ==> $EdgeMatches(ReadVec(cp, pl + i), ReadVec(hyper_edge, i)))
    )))))
}

function {:inline} $EdgeMatches(edge: int, edge_pattern: int): bool {
    edge_pattern == -1 // wildcard
    || edge_pattern == edge
}



function {:inline} $SameLocation<T1, T2>(m1: $Mutation T1, m2: $Mutation T2): bool {
    l#$Mutation(m1) == l#$Mutation(m2)
}

function {:inline} $HasGlobalLocation<T>(m: $Mutation T): bool {
    is#$Global(l#$Mutation(m))
}

function {:inline} $HasLocalLocation<T>(m: $Mutation T, idx: int): bool {
    l#$Mutation(m) == $Local(idx)
}

function {:inline} $GlobalLocationAddress<T>(m: $Mutation T): int {
    a#$Global(l#$Mutation(m))
}



// Tests whether resource exists.
function {:inline} $ResourceExists<T>(m: $Memory T, addr: int): bool {
    domain#$Memory(m)[addr]
}

// Obtains Value of given resource.
function {:inline} $ResourceValue<T>(m: $Memory T, addr: int): T {
    contents#$Memory(m)[addr]
}

// Update resource.
function {:inline} $ResourceUpdate<T>(m: $Memory T, a: int, v: T): $Memory T {
    $Memory(domain#$Memory(m)[a := true], contents#$Memory(m)[a := v])
}

// Remove resource.
function {:inline} $ResourceRemove<T>(m: $Memory T, a: int): $Memory T {
    $Memory(domain#$Memory(m)[a := false], contents#$Memory(m))
}

// Copies resource from memory s to m.
function {:inline} $ResourceCopy<T>(m: $Memory T, s: $Memory T, a: int): $Memory T {
    $Memory(domain#$Memory(m)[a := domain#$Memory(s)[a]],
            contents#$Memory(m)[a := contents#$Memory(s)[a]])
}



// ============================================================================================
// Abort Handling

var $abort_flag: bool;
var $abort_code: int;

function {:inline} $process_abort_code(code: int): int {
    code
}

const $EXEC_FAILURE_CODE: int;
axiom $EXEC_FAILURE_CODE == -1;

// TODO(wrwg): currently we map aborts of native functions like those for vectors also to
//   execution failure. This may need to be aligned with what the runtime actually does.

procedure {:inline 1} $ExecFailureAbort() {
    $abort_flag := true;
    $abort_code := $EXEC_FAILURE_CODE;
}

procedure {:inline 1} $InitVerification() {
    // Set abort_flag to false, and havoc abort_code
    $abort_flag := false;
    havoc $abort_code;
    // Initialize event store
    call $InitEventStore();
}

// ============================================================================================
// Instructions


procedure {:inline 1} $CastU8(src: int) returns (dst: int)
{
    if (src > $MAX_U8) {
        call $ExecFailureAbort();
        return;
    }
    dst := src;
}

procedure {:inline 1} $CastU64(src: int) returns (dst: int)
{
    if (src > $MAX_U64) {
        call $ExecFailureAbort();
        return;
    }
    dst := src;
}

procedure {:inline 1} $CastU128(src: int) returns (dst: int)
{
    if (src > $MAX_U128) {
        call $ExecFailureAbort();
        return;
    }
    dst := src;
}

procedure {:inline 1} $AddU8(src1: int, src2: int) returns (dst: int)
{
    if (src1 + src2 > $MAX_U8) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 + src2;
}

procedure {:inline 1} $AddU64(src1: int, src2: int) returns (dst: int)
{
    if (src1 + src2 > $MAX_U64) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 + src2;
}

procedure {:inline 1} $AddU64_unchecked(src1: int, src2: int) returns (dst: int)
{
    dst := src1 + src2;
}

procedure {:inline 1} $AddU128(src1: int, src2: int) returns (dst: int)
{
    if (src1 + src2 > $MAX_U128) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 + src2;
}

procedure {:inline 1} $AddU128_unchecked(src1: int, src2: int) returns (dst: int)
{
    dst := src1 + src2;
}

procedure {:inline 1} $Sub(src1: int, src2: int) returns (dst: int)
{
    if (src1 < src2) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 - src2;
}

// Note that *not* inlining the shl/shr functions avoids timeouts. It appears that Z3 can reason
// better about this if it is an axiomatized function.
function $shl(src1: int, p: int): int {
    if p == 8 then src1 * 256
    else if p == 16 then src1 * 65536
    else if p == 32 then src1 * 4294967296
    else if p == 64 then src1 * 18446744073709551616
    // Value is undefined, otherwise.
    else -1
}

function $shr(src1: int, p: int): int {
    if p == 8 then src1 div 256
    else if p == 16 then src1 div 65536
    else if p == 32 then src1 div 4294967296
    else if p == 64 then src1 div 18446744073709551616
    // Value is undefined, otherwise.
    else -1
}

// TODO: fix this and $Shr to drop bits on overflow. Requires $Shl8, $Shl64, and $Shl128
procedure {:inline 1} $Shl(src1: int, src2: int) returns (dst: int)
{
    var res: int;
    res := $shl(src1, src2);
    assert res >= 0;   // restriction: shift argument must be 8, 16, 32, or 64
    dst := res;
}

procedure {:inline 1} $Shr(src1: int, src2: int) returns (dst: int)
{
    var res: int;
    res := $shr(src1, src2);
    assert res >= 0;   // restriction: shift argument must be 8, 16, 32, or 64
    dst := res;
}

procedure {:inline 1} $MulU8(src1: int, src2: int) returns (dst: int)
{
    if (src1 * src2 > $MAX_U8) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 * src2;
}

procedure {:inline 1} $MulU64(src1: int, src2: int) returns (dst: int)
{
    if (src1 * src2 > $MAX_U64) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 * src2;
}

procedure {:inline 1} $MulU128(src1: int, src2: int) returns (dst: int)
{
    if (src1 * src2 > $MAX_U128) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 * src2;
}

procedure {:inline 1} $Div(src1: int, src2: int) returns (dst: int)
{
    if (src2 == 0) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 div src2;
}

procedure {:inline 1} $Mod(src1: int, src2: int) returns (dst: int)
{
    if (src2 == 0) {
        call $ExecFailureAbort();
        return;
    }
    dst := src1 mod src2;
}

procedure {:inline 1} $ArithBinaryUnimplemented(src1: int, src2: int) returns (dst: int);

procedure {:inline 1} $Lt(src1: int, src2: int) returns (dst: bool)
{
    dst := src1 < src2;
}

procedure {:inline 1} $Gt(src1: int, src2: int) returns (dst: bool)
{
    dst := src1 > src2;
}

procedure {:inline 1} $Le(src1: int, src2: int) returns (dst: bool)
{
    dst := src1 <= src2;
}

procedure {:inline 1} $Ge(src1: int, src2: int) returns (dst: bool)
{
    dst := src1 >= src2;
}

procedure {:inline 1} $And(src1: bool, src2: bool) returns (dst: bool)
{
    dst := src1 && src2;
}

procedure {:inline 1} $Or(src1: bool, src2: bool) returns (dst: bool)
{
    dst := src1 || src2;
}

procedure {:inline 1} $Not(src: bool) returns (dst: bool)
{
    dst := !src;
}

// Pack and Unpack are auto-generated for each type T


// ==================================================================================
// Native Vector

function {:inline} $SliceVecByRange<T>(v: Vec T, r: $Range): Vec T {
    SliceVec(v, lb#$Range(r), ub#$Range(r))
}

// ----------------------------------------------------------------------------------
// Native Vector implementation for element type `#0`

// Not inlined. It appears faster this way.
function $IsEqual'vec'#0''(v1: Vec (#0), v2: Vec (#0)): bool {
    LenVec(v1) == LenVec(v2) &&
    (forall i: int:: InRangeVec(v1, i) ==> $IsEqual'#0'(ReadVec(v1, i), ReadVec(v2, i)))
}

// Not inlined.
function $IsValid'vec'#0''(v: Vec (#0)): bool {
    $IsValid'u64'(LenVec(v)) &&
    (forall i: int:: InRangeVec(v, i) ==> $IsValid'#0'(ReadVec(v, i)))
}


function {:inline} $ContainsVec'#0'(v: Vec (#0), e: #0): bool {
    (exists i: int :: $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'#0'(ReadVec(v, i), e))
}

function $IndexOfVec'#0'(v: Vec (#0), e: #0): int;
axiom (forall v: Vec (#0), e: #0:: {$IndexOfVec'#0'(v, e)}
    (var i := $IndexOfVec'#0'(v, e);
     if (!$ContainsVec'#0'(v, e)) then i == -1
     else $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'#0'(ReadVec(v, i), e) &&
        (forall j: int :: $IsValid'u64'(j) && j >= 0 && j < i ==> !$IsEqual'#0'(ReadVec(v, j), e))));


function {:inline} $RangeVec'#0'(v: Vec (#0)): $Range {
    $Range(0, LenVec(v))
}


function {:inline} $EmptyVec'#0'(): Vec (#0) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_empty'#0'() returns (v: Vec (#0)) {
    v := EmptyVec();
}

function {:inline} $1_Vector_$empty'#0'(): Vec (#0) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_is_empty'#0'(v: Vec (#0)) returns (b: bool) {
    b := IsEmptyVec(v);
}

procedure {:inline 1} $1_Vector_push_back'#0'(m: $Mutation (Vec (#0)), val: #0) returns (m': $Mutation (Vec (#0))) {
    m' := $UpdateMutation(m, ExtendVec($Dereference(m), val));
}

function {:inline} $1_Vector_$push_back'#0'(v: Vec (#0), val: #0): Vec (#0) {
    ExtendVec(v, val)
}

procedure {:inline 1} $1_Vector_pop_back'#0'(m: $Mutation (Vec (#0))) returns (e: #0, m': $Mutation (Vec (#0))) {
    var v: Vec (#0);
    var len: int;
    v := $Dereference(m);
    len := LenVec(v);
    if (len == 0) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, len-1);
    m' := $UpdateMutation(m, RemoveVec(v));
}

procedure {:inline 1} $1_Vector_append'#0'(m: $Mutation (Vec (#0)), other: Vec (#0)) returns (m': $Mutation (Vec (#0))) {
    m' := $UpdateMutation(m, ConcatVec($Dereference(m), other));
}

procedure {:inline 1} $1_Vector_reverse'#0'(m: $Mutation (Vec (#0))) returns (m': $Mutation (Vec (#0))) {
    m' := $UpdateMutation(m, ReverseVec($Dereference(m)));
}

procedure {:inline 1} $1_Vector_length'#0'(v: Vec (#0)) returns (l: int) {
    l := LenVec(v);
}

function {:inline} $1_Vector_$length'#0'(v: Vec (#0)): int {
    LenVec(v)
}

procedure {:inline 1} $1_Vector_borrow'#0'(v: Vec (#0), i: int) returns (dst: #0) {
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    dst := ReadVec(v, i);
}

function {:inline} $1_Vector_$borrow'#0'(v: Vec (#0), i: int): #0 {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_borrow_mut'#0'(m: $Mutation (Vec (#0)), index: int)
returns (dst: $Mutation (#0), m': $Mutation (Vec (#0)))
{
    var v: Vec (#0);
    v := $Dereference(m);
    if (!InRangeVec(v, index)) {
        call $ExecFailureAbort();
        return;
    }
    dst := $Mutation(l#$Mutation(m), ExtendVec(p#$Mutation(m), index), ReadVec(v, index));
    m' := m;
}

function {:inline} $1_Vector_$borrow_mut'#0'(v: Vec (#0), i: int): #0 {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_destroy_empty'#0'(v: Vec (#0)) {
    if (!IsEmptyVec(v)) {
      call $ExecFailureAbort();
    }
}

procedure {:inline 1} $1_Vector_swap'#0'(m: $Mutation (Vec (#0)), i: int, j: int) returns (m': $Mutation (Vec (#0)))
{
    var v: Vec (#0);
    v := $Dereference(m);
    if (!InRangeVec(v, i) || !InRangeVec(v, j)) {
        call $ExecFailureAbort();
        return;
    }
    m' := $UpdateMutation(m, SwapVec(v, i, j));
}

function {:inline} $1_Vector_$swap'#0'(v: Vec (#0), i: int, j: int): Vec (#0) {
    SwapVec(v, i, j)
}

procedure {:inline 1} $1_Vector_remove'#0'(m: $Mutation (Vec (#0)), i: int) returns (e: #0, m': $Mutation (Vec (#0)))
{
    var v: Vec (#0);

    v := $Dereference(m);

    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveAtVec(v, i));
}

procedure {:inline 1} $1_Vector_swap_remove'#0'(m: $Mutation (Vec (#0)), i: int) returns (e: #0, m': $Mutation (Vec (#0)))
{
    var len: int;
    var v: Vec (#0);

    v := $Dereference(m);
    len := LenVec(v);
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveVec(SwapVec(v, i, len-1)));
}

procedure {:inline 1} $1_Vector_contains'#0'(v: Vec (#0), e: #0) returns (res: bool)  {
    res := $ContainsVec'#0'(v, e);
}

procedure {:inline 1}
$1_Vector_index_of'#0'(v: Vec (#0), e: #0) returns (res1: bool, res2: int) {
    res2 := $IndexOfVec'#0'(v, e);
    if (res2 >= 0) {
        res1 := true;
    } else {
        res1 := false;
        res2 := 0;
    }
}


// ----------------------------------------------------------------------------------
// Native Vector implementation for element type `$1_Account_KeyRotationCapability`

// Not inlined. It appears faster this way.
function $IsEqual'vec'$1_Account_KeyRotationCapability''(v1: Vec ($1_Account_KeyRotationCapability), v2: Vec ($1_Account_KeyRotationCapability)): bool {
    LenVec(v1) == LenVec(v2) &&
    (forall i: int:: InRangeVec(v1, i) ==> $IsEqual'$1_Account_KeyRotationCapability'(ReadVec(v1, i), ReadVec(v2, i)))
}

// Not inlined.
function $IsValid'vec'$1_Account_KeyRotationCapability''(v: Vec ($1_Account_KeyRotationCapability)): bool {
    $IsValid'u64'(LenVec(v)) &&
    (forall i: int:: InRangeVec(v, i) ==> $IsValid'$1_Account_KeyRotationCapability'(ReadVec(v, i)))
}


function {:inline} $ContainsVec'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), e: $1_Account_KeyRotationCapability): bool {
    (exists i: int :: $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'$1_Account_KeyRotationCapability'(ReadVec(v, i), e))
}

function $IndexOfVec'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), e: $1_Account_KeyRotationCapability): int;
axiom (forall v: Vec ($1_Account_KeyRotationCapability), e: $1_Account_KeyRotationCapability:: {$IndexOfVec'$1_Account_KeyRotationCapability'(v, e)}
    (var i := $IndexOfVec'$1_Account_KeyRotationCapability'(v, e);
     if (!$ContainsVec'$1_Account_KeyRotationCapability'(v, e)) then i == -1
     else $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'$1_Account_KeyRotationCapability'(ReadVec(v, i), e) &&
        (forall j: int :: $IsValid'u64'(j) && j >= 0 && j < i ==> !$IsEqual'$1_Account_KeyRotationCapability'(ReadVec(v, j), e))));


function {:inline} $RangeVec'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability)): $Range {
    $Range(0, LenVec(v))
}


function {:inline} $EmptyVec'$1_Account_KeyRotationCapability'(): Vec ($1_Account_KeyRotationCapability) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_empty'$1_Account_KeyRotationCapability'() returns (v: Vec ($1_Account_KeyRotationCapability)) {
    v := EmptyVec();
}

function {:inline} $1_Vector_$empty'$1_Account_KeyRotationCapability'(): Vec ($1_Account_KeyRotationCapability) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_is_empty'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability)) returns (b: bool) {
    b := IsEmptyVec(v);
}

procedure {:inline 1} $1_Vector_push_back'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), val: $1_Account_KeyRotationCapability) returns (m': $Mutation (Vec ($1_Account_KeyRotationCapability))) {
    m' := $UpdateMutation(m, ExtendVec($Dereference(m), val));
}

function {:inline} $1_Vector_$push_back'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), val: $1_Account_KeyRotationCapability): Vec ($1_Account_KeyRotationCapability) {
    ExtendVec(v, val)
}

procedure {:inline 1} $1_Vector_pop_back'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability))) returns (e: $1_Account_KeyRotationCapability, m': $Mutation (Vec ($1_Account_KeyRotationCapability))) {
    var v: Vec ($1_Account_KeyRotationCapability);
    var len: int;
    v := $Dereference(m);
    len := LenVec(v);
    if (len == 0) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, len-1);
    m' := $UpdateMutation(m, RemoveVec(v));
}

procedure {:inline 1} $1_Vector_append'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), other: Vec ($1_Account_KeyRotationCapability)) returns (m': $Mutation (Vec ($1_Account_KeyRotationCapability))) {
    m' := $UpdateMutation(m, ConcatVec($Dereference(m), other));
}

procedure {:inline 1} $1_Vector_reverse'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability))) returns (m': $Mutation (Vec ($1_Account_KeyRotationCapability))) {
    m' := $UpdateMutation(m, ReverseVec($Dereference(m)));
}

procedure {:inline 1} $1_Vector_length'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability)) returns (l: int) {
    l := LenVec(v);
}

function {:inline} $1_Vector_$length'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability)): int {
    LenVec(v)
}

procedure {:inline 1} $1_Vector_borrow'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), i: int) returns (dst: $1_Account_KeyRotationCapability) {
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    dst := ReadVec(v, i);
}

function {:inline} $1_Vector_$borrow'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), i: int): $1_Account_KeyRotationCapability {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_borrow_mut'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), index: int)
returns (dst: $Mutation ($1_Account_KeyRotationCapability), m': $Mutation (Vec ($1_Account_KeyRotationCapability)))
{
    var v: Vec ($1_Account_KeyRotationCapability);
    v := $Dereference(m);
    if (!InRangeVec(v, index)) {
        call $ExecFailureAbort();
        return;
    }
    dst := $Mutation(l#$Mutation(m), ExtendVec(p#$Mutation(m), index), ReadVec(v, index));
    m' := m;
}

function {:inline} $1_Vector_$borrow_mut'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), i: int): $1_Account_KeyRotationCapability {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_destroy_empty'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability)) {
    if (!IsEmptyVec(v)) {
      call $ExecFailureAbort();
    }
}

procedure {:inline 1} $1_Vector_swap'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), i: int, j: int) returns (m': $Mutation (Vec ($1_Account_KeyRotationCapability)))
{
    var v: Vec ($1_Account_KeyRotationCapability);
    v := $Dereference(m);
    if (!InRangeVec(v, i) || !InRangeVec(v, j)) {
        call $ExecFailureAbort();
        return;
    }
    m' := $UpdateMutation(m, SwapVec(v, i, j));
}

function {:inline} $1_Vector_$swap'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), i: int, j: int): Vec ($1_Account_KeyRotationCapability) {
    SwapVec(v, i, j)
}

procedure {:inline 1} $1_Vector_remove'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), i: int) returns (e: $1_Account_KeyRotationCapability, m': $Mutation (Vec ($1_Account_KeyRotationCapability)))
{
    var v: Vec ($1_Account_KeyRotationCapability);

    v := $Dereference(m);

    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveAtVec(v, i));
}

procedure {:inline 1} $1_Vector_swap_remove'$1_Account_KeyRotationCapability'(m: $Mutation (Vec ($1_Account_KeyRotationCapability)), i: int) returns (e: $1_Account_KeyRotationCapability, m': $Mutation (Vec ($1_Account_KeyRotationCapability)))
{
    var len: int;
    var v: Vec ($1_Account_KeyRotationCapability);

    v := $Dereference(m);
    len := LenVec(v);
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveVec(SwapVec(v, i, len-1)));
}

procedure {:inline 1} $1_Vector_contains'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), e: $1_Account_KeyRotationCapability) returns (res: bool)  {
    res := $ContainsVec'$1_Account_KeyRotationCapability'(v, e);
}

procedure {:inline 1}
$1_Vector_index_of'$1_Account_KeyRotationCapability'(v: Vec ($1_Account_KeyRotationCapability), e: $1_Account_KeyRotationCapability) returns (res1: bool, res2: int) {
    res2 := $IndexOfVec'$1_Account_KeyRotationCapability'(v, e);
    if (res2 >= 0) {
        res1 := true;
    } else {
        res1 := false;
        res2 := 0;
    }
}


// ----------------------------------------------------------------------------------
// Native Vector implementation for element type `$1_Account_WithdrawCapability`

// Not inlined. It appears faster this way.
function $IsEqual'vec'$1_Account_WithdrawCapability''(v1: Vec ($1_Account_WithdrawCapability), v2: Vec ($1_Account_WithdrawCapability)): bool {
    LenVec(v1) == LenVec(v2) &&
    (forall i: int:: InRangeVec(v1, i) ==> $IsEqual'$1_Account_WithdrawCapability'(ReadVec(v1, i), ReadVec(v2, i)))
}

// Not inlined.
function $IsValid'vec'$1_Account_WithdrawCapability''(v: Vec ($1_Account_WithdrawCapability)): bool {
    $IsValid'u64'(LenVec(v)) &&
    (forall i: int:: InRangeVec(v, i) ==> $IsValid'$1_Account_WithdrawCapability'(ReadVec(v, i)))
}


function {:inline} $ContainsVec'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), e: $1_Account_WithdrawCapability): bool {
    (exists i: int :: $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'$1_Account_WithdrawCapability'(ReadVec(v, i), e))
}

function $IndexOfVec'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), e: $1_Account_WithdrawCapability): int;
axiom (forall v: Vec ($1_Account_WithdrawCapability), e: $1_Account_WithdrawCapability:: {$IndexOfVec'$1_Account_WithdrawCapability'(v, e)}
    (var i := $IndexOfVec'$1_Account_WithdrawCapability'(v, e);
     if (!$ContainsVec'$1_Account_WithdrawCapability'(v, e)) then i == -1
     else $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'$1_Account_WithdrawCapability'(ReadVec(v, i), e) &&
        (forall j: int :: $IsValid'u64'(j) && j >= 0 && j < i ==> !$IsEqual'$1_Account_WithdrawCapability'(ReadVec(v, j), e))));


function {:inline} $RangeVec'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)): $Range {
    $Range(0, LenVec(v))
}


function {:inline} $EmptyVec'$1_Account_WithdrawCapability'(): Vec ($1_Account_WithdrawCapability) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_empty'$1_Account_WithdrawCapability'() returns (v: Vec ($1_Account_WithdrawCapability)) {
    v := EmptyVec();
}

function {:inline} $1_Vector_$empty'$1_Account_WithdrawCapability'(): Vec ($1_Account_WithdrawCapability) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_is_empty'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)) returns (b: bool) {
    b := IsEmptyVec(v);
}

procedure {:inline 1} $1_Vector_push_back'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), val: $1_Account_WithdrawCapability) returns (m': $Mutation (Vec ($1_Account_WithdrawCapability))) {
    m' := $UpdateMutation(m, ExtendVec($Dereference(m), val));
}

function {:inline} $1_Vector_$push_back'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), val: $1_Account_WithdrawCapability): Vec ($1_Account_WithdrawCapability) {
    ExtendVec(v, val)
}

procedure {:inline 1} $1_Vector_pop_back'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability))) returns (e: $1_Account_WithdrawCapability, m': $Mutation (Vec ($1_Account_WithdrawCapability))) {
    var v: Vec ($1_Account_WithdrawCapability);
    var len: int;
    v := $Dereference(m);
    len := LenVec(v);
    if (len == 0) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, len-1);
    m' := $UpdateMutation(m, RemoveVec(v));
}

procedure {:inline 1} $1_Vector_append'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), other: Vec ($1_Account_WithdrawCapability)) returns (m': $Mutation (Vec ($1_Account_WithdrawCapability))) {
    m' := $UpdateMutation(m, ConcatVec($Dereference(m), other));
}

procedure {:inline 1} $1_Vector_reverse'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability))) returns (m': $Mutation (Vec ($1_Account_WithdrawCapability))) {
    m' := $UpdateMutation(m, ReverseVec($Dereference(m)));
}

procedure {:inline 1} $1_Vector_length'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)) returns (l: int) {
    l := LenVec(v);
}

function {:inline} $1_Vector_$length'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)): int {
    LenVec(v)
}

procedure {:inline 1} $1_Vector_borrow'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), i: int) returns (dst: $1_Account_WithdrawCapability) {
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    dst := ReadVec(v, i);
}

function {:inline} $1_Vector_$borrow'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), i: int): $1_Account_WithdrawCapability {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_borrow_mut'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), index: int)
returns (dst: $Mutation ($1_Account_WithdrawCapability), m': $Mutation (Vec ($1_Account_WithdrawCapability)))
{
    var v: Vec ($1_Account_WithdrawCapability);
    v := $Dereference(m);
    if (!InRangeVec(v, index)) {
        call $ExecFailureAbort();
        return;
    }
    dst := $Mutation(l#$Mutation(m), ExtendVec(p#$Mutation(m), index), ReadVec(v, index));
    m' := m;
}

function {:inline} $1_Vector_$borrow_mut'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), i: int): $1_Account_WithdrawCapability {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_destroy_empty'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)) {
    if (!IsEmptyVec(v)) {
      call $ExecFailureAbort();
    }
}

procedure {:inline 1} $1_Vector_swap'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), i: int, j: int) returns (m': $Mutation (Vec ($1_Account_WithdrawCapability)))
{
    var v: Vec ($1_Account_WithdrawCapability);
    v := $Dereference(m);
    if (!InRangeVec(v, i) || !InRangeVec(v, j)) {
        call $ExecFailureAbort();
        return;
    }
    m' := $UpdateMutation(m, SwapVec(v, i, j));
}

function {:inline} $1_Vector_$swap'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), i: int, j: int): Vec ($1_Account_WithdrawCapability) {
    SwapVec(v, i, j)
}

procedure {:inline 1} $1_Vector_remove'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), i: int) returns (e: $1_Account_WithdrawCapability, m': $Mutation (Vec ($1_Account_WithdrawCapability)))
{
    var v: Vec ($1_Account_WithdrawCapability);

    v := $Dereference(m);

    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveAtVec(v, i));
}

procedure {:inline 1} $1_Vector_swap_remove'$1_Account_WithdrawCapability'(m: $Mutation (Vec ($1_Account_WithdrawCapability)), i: int) returns (e: $1_Account_WithdrawCapability, m': $Mutation (Vec ($1_Account_WithdrawCapability)))
{
    var len: int;
    var v: Vec ($1_Account_WithdrawCapability);

    v := $Dereference(m);
    len := LenVec(v);
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveVec(SwapVec(v, i, len-1)));
}

procedure {:inline 1} $1_Vector_contains'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), e: $1_Account_WithdrawCapability) returns (res: bool)  {
    res := $ContainsVec'$1_Account_WithdrawCapability'(v, e);
}

procedure {:inline 1}
$1_Vector_index_of'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability), e: $1_Account_WithdrawCapability) returns (res1: bool, res2: int) {
    res2 := $IndexOfVec'$1_Account_WithdrawCapability'(v, e);
    if (res2 >= 0) {
        res1 := true;
    } else {
        res1 := false;
        res2 := 0;
    }
}


// ----------------------------------------------------------------------------------
// Native Vector implementation for element type `u8`

// Not inlined. It appears faster this way.
function $IsEqual'vec'u8''(v1: Vec (int), v2: Vec (int)): bool {
    LenVec(v1) == LenVec(v2) &&
    (forall i: int:: InRangeVec(v1, i) ==> $IsEqual'u8'(ReadVec(v1, i), ReadVec(v2, i)))
}

// Not inlined.
function $IsValid'vec'u8''(v: Vec (int)): bool {
    $IsValid'u64'(LenVec(v)) &&
    (forall i: int:: InRangeVec(v, i) ==> $IsValid'u8'(ReadVec(v, i)))
}


function {:inline} $ContainsVec'u8'(v: Vec (int), e: int): bool {
    (exists i: int :: $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'u8'(ReadVec(v, i), e))
}

function $IndexOfVec'u8'(v: Vec (int), e: int): int;
axiom (forall v: Vec (int), e: int:: {$IndexOfVec'u8'(v, e)}
    (var i := $IndexOfVec'u8'(v, e);
     if (!$ContainsVec'u8'(v, e)) then i == -1
     else $IsValid'u64'(i) && InRangeVec(v, i) && $IsEqual'u8'(ReadVec(v, i), e) &&
        (forall j: int :: $IsValid'u64'(j) && j >= 0 && j < i ==> !$IsEqual'u8'(ReadVec(v, j), e))));


function {:inline} $RangeVec'u8'(v: Vec (int)): $Range {
    $Range(0, LenVec(v))
}


function {:inline} $EmptyVec'u8'(): Vec (int) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_empty'u8'() returns (v: Vec (int)) {
    v := EmptyVec();
}

function {:inline} $1_Vector_$empty'u8'(): Vec (int) {
    EmptyVec()
}

procedure {:inline 1} $1_Vector_is_empty'u8'(v: Vec (int)) returns (b: bool) {
    b := IsEmptyVec(v);
}

procedure {:inline 1} $1_Vector_push_back'u8'(m: $Mutation (Vec (int)), val: int) returns (m': $Mutation (Vec (int))) {
    m' := $UpdateMutation(m, ExtendVec($Dereference(m), val));
}

function {:inline} $1_Vector_$push_back'u8'(v: Vec (int), val: int): Vec (int) {
    ExtendVec(v, val)
}

procedure {:inline 1} $1_Vector_pop_back'u8'(m: $Mutation (Vec (int))) returns (e: int, m': $Mutation (Vec (int))) {
    var v: Vec (int);
    var len: int;
    v := $Dereference(m);
    len := LenVec(v);
    if (len == 0) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, len-1);
    m' := $UpdateMutation(m, RemoveVec(v));
}

procedure {:inline 1} $1_Vector_append'u8'(m: $Mutation (Vec (int)), other: Vec (int)) returns (m': $Mutation (Vec (int))) {
    m' := $UpdateMutation(m, ConcatVec($Dereference(m), other));
}

procedure {:inline 1} $1_Vector_reverse'u8'(m: $Mutation (Vec (int))) returns (m': $Mutation (Vec (int))) {
    m' := $UpdateMutation(m, ReverseVec($Dereference(m)));
}

procedure {:inline 1} $1_Vector_length'u8'(v: Vec (int)) returns (l: int) {
    l := LenVec(v);
}

function {:inline} $1_Vector_$length'u8'(v: Vec (int)): int {
    LenVec(v)
}

procedure {:inline 1} $1_Vector_borrow'u8'(v: Vec (int), i: int) returns (dst: int) {
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    dst := ReadVec(v, i);
}

function {:inline} $1_Vector_$borrow'u8'(v: Vec (int), i: int): int {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_borrow_mut'u8'(m: $Mutation (Vec (int)), index: int)
returns (dst: $Mutation (int), m': $Mutation (Vec (int)))
{
    var v: Vec (int);
    v := $Dereference(m);
    if (!InRangeVec(v, index)) {
        call $ExecFailureAbort();
        return;
    }
    dst := $Mutation(l#$Mutation(m), ExtendVec(p#$Mutation(m), index), ReadVec(v, index));
    m' := m;
}

function {:inline} $1_Vector_$borrow_mut'u8'(v: Vec (int), i: int): int {
    ReadVec(v, i)
}

procedure {:inline 1} $1_Vector_destroy_empty'u8'(v: Vec (int)) {
    if (!IsEmptyVec(v)) {
      call $ExecFailureAbort();
    }
}

procedure {:inline 1} $1_Vector_swap'u8'(m: $Mutation (Vec (int)), i: int, j: int) returns (m': $Mutation (Vec (int)))
{
    var v: Vec (int);
    v := $Dereference(m);
    if (!InRangeVec(v, i) || !InRangeVec(v, j)) {
        call $ExecFailureAbort();
        return;
    }
    m' := $UpdateMutation(m, SwapVec(v, i, j));
}

function {:inline} $1_Vector_$swap'u8'(v: Vec (int), i: int, j: int): Vec (int) {
    SwapVec(v, i, j)
}

procedure {:inline 1} $1_Vector_remove'u8'(m: $Mutation (Vec (int)), i: int) returns (e: int, m': $Mutation (Vec (int)))
{
    var v: Vec (int);

    v := $Dereference(m);

    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveAtVec(v, i));
}

procedure {:inline 1} $1_Vector_swap_remove'u8'(m: $Mutation (Vec (int)), i: int) returns (e: int, m': $Mutation (Vec (int)))
{
    var len: int;
    var v: Vec (int);

    v := $Dereference(m);
    len := LenVec(v);
    if (!InRangeVec(v, i)) {
        call $ExecFailureAbort();
        return;
    }
    e := ReadVec(v, i);
    m' := $UpdateMutation(m, RemoveVec(SwapVec(v, i, len-1)));
}

procedure {:inline 1} $1_Vector_contains'u8'(v: Vec (int), e: int) returns (res: bool)  {
    res := $ContainsVec'u8'(v, e);
}

procedure {:inline 1}
$1_Vector_index_of'u8'(v: Vec (int), e: int) returns (res1: bool, res2: int) {
    res2 := $IndexOfVec'u8'(v, e);
    if (res2 >= 0) {
        res1 := true;
    } else {
        res1 := false;
        res2 := 0;
    }
}


// ==================================================================================
// Native Hash

// Hash is modeled as an otherwise uninterpreted injection.
// In truth, it is not an injection since the domain has greater cardinality
// (arbitrary length vectors) than the co-domain (vectors of length 32).  But it is
// common to assume in code there are no hash collisions in practice.  Fortunately,
// Boogie is not smart enough to recognized that there is an inconsistency.
// FIXME: If we were using a reliable extensional theory of arrays, and if we could use ==
// instead of $IsEqual, we might be able to avoid so many quantified formulas by
// using a sha2_inverse function in the ensures conditions of Hash_sha2_256 to
// assert that sha2/3 are injections without using global quantified axioms.


function $1_Hash_sha2(val: Vec int): Vec int;

// This says that Hash_sha2 is bijective.
axiom (forall v1,v2: Vec int :: {$1_Hash_sha2(v1), $1_Hash_sha2(v2)}
       $IsEqual'vec'u8''(v1, v2) <==> $IsEqual'vec'u8''($1_Hash_sha2(v1), $1_Hash_sha2(v2)));

procedure $1_Hash_sha2_256(val: Vec int) returns (res: Vec int);
ensures res == $1_Hash_sha2(val);     // returns Hash_sha2 Value
ensures $IsValid'vec'u8''(res);    // result is a legal vector of U8s.
ensures LenVec(res) == 32;               // result is 32 bytes.

// Spec version of Move native function.
function {:inline} $1_Hash_$sha2_256(val: Vec int): Vec int {
    $1_Hash_sha2(val)
}

// similarly for Hash_sha3
function $1_Hash_sha3(val: Vec int): Vec int;

axiom (forall v1,v2: Vec int :: {$1_Hash_sha3(v1), $1_Hash_sha3(v2)}
       $IsEqual'vec'u8''(v1, v2) <==> $IsEqual'vec'u8''($1_Hash_sha3(v1), $1_Hash_sha3(v2)));

procedure $1_Hash_sha3_256(val: Vec int) returns (res: Vec int);
ensures res == $1_Hash_sha3(val);     // returns Hash_sha3 Value
ensures $IsValid'vec'u8''(res);    // result is a legal vector of U8s.
ensures LenVec(res) == 32;               // result is 32 bytes.

// Spec version of Move native function.
function {:inline} $1_Hash_$sha3_256(val: Vec int): Vec int {
    $1_Hash_sha3(val)
}

// ==================================================================================
// Native diem_account

procedure {:inline 1} $1_DiemAccount_create_signer(
  addr: int
) returns (signer: $signer) {
    // A signer is currently identical to an address.
    signer := $signer(addr);
}

procedure {:inline 1} $1_DiemAccount_destroy_signer(
  signer: $signer
) {
  return;
}

// ==================================================================================
// Native account

procedure {:inline 1} $1_Account_create_signer(
  addr: int
) returns (signer: $signer) {
    // A signer is currently identical to an address.
    signer := $signer(addr);
}

// ==================================================================================
// Native Signer

type {:datatype} $signer;
function {:constructor} $signer($addr: int): $signer;
function {:inline} $IsValid'signer'(s: $signer): bool {
    $IsValid'address'($addr#$signer(s))
}
function {:inline} $IsEqual'signer'(s1: $signer, s2: $signer): bool {
    s1 == s2
}

procedure {:inline 1} $1_Signer_borrow_address(signer: $signer) returns (res: int) {
    res := $addr#$signer(signer);
}

function {:inline} $1_Signer_$borrow_address(signer: $signer): int
{
    $addr#$signer(signer)
}

function $1_Signer_is_txn_signer(s: $signer): bool;

function $1_Signer_is_txn_signer_addr(a: int): bool;


// ==================================================================================
// Native signature

// Signature related functionality is handled via uninterpreted functions. This is sound
// currently because we verify every code path based on signature verification with
// an arbitrary interpretation.

function $1_Signature_$ed25519_validate_pubkey(public_key: Vec int): bool;
function $1_Signature_$ed25519_verify(signature: Vec int, public_key: Vec int, message: Vec int): bool;

// Needed because we do not have extensional equality:
axiom (forall k1, k2: Vec int ::
    {$1_Signature_$ed25519_validate_pubkey(k1), $1_Signature_$ed25519_validate_pubkey(k2)}
    $IsEqual'vec'u8''(k1, k2) ==> $1_Signature_$ed25519_validate_pubkey(k1) == $1_Signature_$ed25519_validate_pubkey(k2));
axiom (forall s1, s2, k1, k2, m1, m2: Vec int ::
    {$1_Signature_$ed25519_verify(s1, k1, m1), $1_Signature_$ed25519_verify(s2, k2, m2)}
    $IsEqual'vec'u8''(s1, s2) && $IsEqual'vec'u8''(k1, k2) && $IsEqual'vec'u8''(m1, m2)
    ==> $1_Signature_$ed25519_verify(s1, k1, m1) == $1_Signature_$ed25519_verify(s2, k2, m2));


procedure {:inline 1} $1_Signature_ed25519_validate_pubkey(public_key: Vec int) returns (res: bool) {
    res := $1_Signature_$ed25519_validate_pubkey(public_key);
}

procedure {:inline 1} $1_Signature_ed25519_verify(
        signature: Vec int, public_key: Vec int, message: Vec int) returns (res: bool) {
    res := $1_Signature_$ed25519_verify(signature, public_key, message);
}


// ==================================================================================
// Native BCS::serialize

procedure $1_BCS_to_address(v: Vec int) returns (res: int);

// ----------------------------------------------------------------------------------
// Native Token and Debug
procedure $1_Token_name_of<T>(t_E: T) returns (res1: int, res2: Vec int, res3: Vec int);
procedure $1_Debug_print<T>(x: T);
procedure $1_Debug_print_stack_trace();


// ==================================================================================
// Native Event module




// Publishing a generator does nothing. Currently we just ignore this function and do not represent generators
// at all because they are not publicly exposed by the Event module.
// TODO: we should check (and abort with the right code) if a generator already exists for
// the signer.

procedure {:inline 1} $1_Event_publish_generator(signer: $signer) {
}


// Generic code for dealing with mutations (havoc) still requires type and memory declarations.
type $1_Event_EventHandleGenerator;
var $1_Event_EventHandleGenerator_$memory: $Memory $1_Event_EventHandleGenerator;

// Abstract type of event handles.
type $1_Event_EventHandle;

// Global state to implement uniqueness of event handles.
var $1_Event_EventHandles: [$1_Event_EventHandle]bool;

// Universal representation of an an event. For each concrete event type, we generate a constructor.
type {:datatype} $EventRep;

// Representation of EventStore that consists of event streams.
type {:datatype} $EventStore;
function {:constructor} $EventStore(
    counter: int, streams: [$1_Event_EventHandle]Multiset $EventRep): $EventStore;

// Global state holding EventStore.
var $es: $EventStore;

procedure {:inline 1} $InitEventStore() {
    assume $EventStore__is_empty($es);
}

function {:inline} $EventStore__is_empty(es: $EventStore): bool {
    (counter#$EventStore(es) == 0) &&
    (forall handle: $1_Event_EventHandle ::
        (var stream := streams#$EventStore(es)[handle];
        IsEmptyMultiset(stream)))
}

// This function returns (es1 - es2). This function assumes that es2 is a subset of es1.
function {:inline} $EventStore__subtract(es1: $EventStore, es2: $EventStore): $EventStore {
    $EventStore(counter#$EventStore(es1)-counter#$EventStore(es2),
        (lambda handle: $1_Event_EventHandle ::
        SubtractMultiset(
            streams#$EventStore(es1)[handle],
            streams#$EventStore(es2)[handle])))
}

function {:inline} $EventStore__is_subset(es1: $EventStore, es2: $EventStore): bool {
    (counter#$EventStore(es1) <= counter#$EventStore(es2)) &&
    (forall handle: $1_Event_EventHandle ::
        IsSubsetMultiset(
            streams#$EventStore(es1)[handle],
            streams#$EventStore(es2)[handle]
        )
    )
}

procedure {:inline 1} $EventStore__diverge(es: $EventStore) returns (es': $EventStore) {
    assume $EventStore__is_subset(es, es');
}

const $EmptyEventStore: $EventStore;
axiom $EventStore__is_empty($EmptyEventStore);

// ----------------------------------------------------------------------------------
// Native Event implementation for element type `$1_Account_AcceptTokenEvent`

// Map type specific handle to universal one.
type $1_Event_EventHandle'$1_Account_AcceptTokenEvent' = $1_Event_EventHandle;

function {:inline} $IsEqual'$1_Event_EventHandle'$1_Account_AcceptTokenEvent''(a: $1_Event_EventHandle'$1_Account_AcceptTokenEvent', b: $1_Event_EventHandle'$1_Account_AcceptTokenEvent'): bool {
    a == b
}

function $IsValid'$1_Event_EventHandle'$1_Account_AcceptTokenEvent''(h: $1_Event_EventHandle'$1_Account_AcceptTokenEvent'): bool {
    true
}

// Embed event `$1_Account_AcceptTokenEvent` into universal $EventRep
function {:constructor} $ToEventRep'$1_Account_AcceptTokenEvent'(e: $1_Account_AcceptTokenEvent): $EventRep;
axiom (forall v1, v2: $1_Account_AcceptTokenEvent :: {$ToEventRep'$1_Account_AcceptTokenEvent'(v1), $ToEventRep'$1_Account_AcceptTokenEvent'(v2)}
    $IsEqual'$1_Account_AcceptTokenEvent'(v1, v2) <==> $ToEventRep'$1_Account_AcceptTokenEvent'(v1) == $ToEventRep'$1_Account_AcceptTokenEvent'(v2));

// Creates a new event handle. This ensures each time it is called that a unique new abstract event handler is
// returned.
// TODO: we should check (and abort with the right code) if no generator exists for the signer.
procedure {:inline 1} $1_Event_new_event_handle'$1_Account_AcceptTokenEvent'(signer: $signer) returns (res: $1_Event_EventHandle'$1_Account_AcceptTokenEvent') {
    assume $1_Event_EventHandles[res] == false;
    $1_Event_EventHandles := $1_Event_EventHandles[res := true];
}

// This boogie procedure is the model of `emit_event`. This model abstracts away the `counter` behavior, thus not
// mutating (or increasing) `counter`.
procedure {:inline 1} $1_Event_emit_event'$1_Account_AcceptTokenEvent'(handle_mut: $Mutation $1_Event_EventHandle'$1_Account_AcceptTokenEvent', msg: $1_Account_AcceptTokenEvent)
returns (res: $Mutation $1_Event_EventHandle'$1_Account_AcceptTokenEvent') {
    var handle: $1_Event_EventHandle'$1_Account_AcceptTokenEvent';
    handle := $Dereference(handle_mut);
    $es := $ExtendEventStore'$1_Account_AcceptTokenEvent'($es, handle, msg);
    res := handle_mut;
}

procedure {:inline 1} $1_Event_destroy_handle'$1_Account_AcceptTokenEvent'(handle: $1_Event_EventHandle'$1_Account_AcceptTokenEvent') {
}

function {:inline} $ExtendEventStore'$1_Account_AcceptTokenEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_AcceptTokenEvent', msg: $1_Account_AcceptTokenEvent): $EventStore {
    (var stream := streams#$EventStore(es)[handle];
    (var stream_new := ExtendMultiset(stream, $ToEventRep'$1_Account_AcceptTokenEvent'(msg));
    $EventStore(counter#$EventStore(es)+1, streams#$EventStore(es)[handle := stream_new])))
}

function {:inline} $CondExtendEventStore'$1_Account_AcceptTokenEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_AcceptTokenEvent', msg: $1_Account_AcceptTokenEvent, cond: bool): $EventStore {
    if cond then
        $ExtendEventStore'$1_Account_AcceptTokenEvent'(es, handle, msg)
    else
        es
}


// ----------------------------------------------------------------------------------
// Native Event implementation for element type `$1_Account_DepositEvent`

// Map type specific handle to universal one.
type $1_Event_EventHandle'$1_Account_DepositEvent' = $1_Event_EventHandle;

function {:inline} $IsEqual'$1_Event_EventHandle'$1_Account_DepositEvent''(a: $1_Event_EventHandle'$1_Account_DepositEvent', b: $1_Event_EventHandle'$1_Account_DepositEvent'): bool {
    a == b
}

function $IsValid'$1_Event_EventHandle'$1_Account_DepositEvent''(h: $1_Event_EventHandle'$1_Account_DepositEvent'): bool {
    true
}

// Embed event `$1_Account_DepositEvent` into universal $EventRep
function {:constructor} $ToEventRep'$1_Account_DepositEvent'(e: $1_Account_DepositEvent): $EventRep;
axiom (forall v1, v2: $1_Account_DepositEvent :: {$ToEventRep'$1_Account_DepositEvent'(v1), $ToEventRep'$1_Account_DepositEvent'(v2)}
    $IsEqual'$1_Account_DepositEvent'(v1, v2) <==> $ToEventRep'$1_Account_DepositEvent'(v1) == $ToEventRep'$1_Account_DepositEvent'(v2));

// Creates a new event handle. This ensures each time it is called that a unique new abstract event handler is
// returned.
// TODO: we should check (and abort with the right code) if no generator exists for the signer.
procedure {:inline 1} $1_Event_new_event_handle'$1_Account_DepositEvent'(signer: $signer) returns (res: $1_Event_EventHandle'$1_Account_DepositEvent') {
    assume $1_Event_EventHandles[res] == false;
    $1_Event_EventHandles := $1_Event_EventHandles[res := true];
}

// This boogie procedure is the model of `emit_event`. This model abstracts away the `counter` behavior, thus not
// mutating (or increasing) `counter`.
procedure {:inline 1} $1_Event_emit_event'$1_Account_DepositEvent'(handle_mut: $Mutation $1_Event_EventHandle'$1_Account_DepositEvent', msg: $1_Account_DepositEvent)
returns (res: $Mutation $1_Event_EventHandle'$1_Account_DepositEvent') {
    var handle: $1_Event_EventHandle'$1_Account_DepositEvent';
    handle := $Dereference(handle_mut);
    $es := $ExtendEventStore'$1_Account_DepositEvent'($es, handle, msg);
    res := handle_mut;
}

procedure {:inline 1} $1_Event_destroy_handle'$1_Account_DepositEvent'(handle: $1_Event_EventHandle'$1_Account_DepositEvent') {
}

function {:inline} $ExtendEventStore'$1_Account_DepositEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_DepositEvent', msg: $1_Account_DepositEvent): $EventStore {
    (var stream := streams#$EventStore(es)[handle];
    (var stream_new := ExtendMultiset(stream, $ToEventRep'$1_Account_DepositEvent'(msg));
    $EventStore(counter#$EventStore(es)+1, streams#$EventStore(es)[handle := stream_new])))
}

function {:inline} $CondExtendEventStore'$1_Account_DepositEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_DepositEvent', msg: $1_Account_DepositEvent, cond: bool): $EventStore {
    if cond then
        $ExtendEventStore'$1_Account_DepositEvent'(es, handle, msg)
    else
        es
}


// ----------------------------------------------------------------------------------
// Native Event implementation for element type `$1_Account_WithdrawEvent`

// Map type specific handle to universal one.
type $1_Event_EventHandle'$1_Account_WithdrawEvent' = $1_Event_EventHandle;

function {:inline} $IsEqual'$1_Event_EventHandle'$1_Account_WithdrawEvent''(a: $1_Event_EventHandle'$1_Account_WithdrawEvent', b: $1_Event_EventHandle'$1_Account_WithdrawEvent'): bool {
    a == b
}

function $IsValid'$1_Event_EventHandle'$1_Account_WithdrawEvent''(h: $1_Event_EventHandle'$1_Account_WithdrawEvent'): bool {
    true
}

// Embed event `$1_Account_WithdrawEvent` into universal $EventRep
function {:constructor} $ToEventRep'$1_Account_WithdrawEvent'(e: $1_Account_WithdrawEvent): $EventRep;
axiom (forall v1, v2: $1_Account_WithdrawEvent :: {$ToEventRep'$1_Account_WithdrawEvent'(v1), $ToEventRep'$1_Account_WithdrawEvent'(v2)}
    $IsEqual'$1_Account_WithdrawEvent'(v1, v2) <==> $ToEventRep'$1_Account_WithdrawEvent'(v1) == $ToEventRep'$1_Account_WithdrawEvent'(v2));

// Creates a new event handle. This ensures each time it is called that a unique new abstract event handler is
// returned.
// TODO: we should check (and abort with the right code) if no generator exists for the signer.
procedure {:inline 1} $1_Event_new_event_handle'$1_Account_WithdrawEvent'(signer: $signer) returns (res: $1_Event_EventHandle'$1_Account_WithdrawEvent') {
    assume $1_Event_EventHandles[res] == false;
    $1_Event_EventHandles := $1_Event_EventHandles[res := true];
}

// This boogie procedure is the model of `emit_event`. This model abstracts away the `counter` behavior, thus not
// mutating (or increasing) `counter`.
procedure {:inline 1} $1_Event_emit_event'$1_Account_WithdrawEvent'(handle_mut: $Mutation $1_Event_EventHandle'$1_Account_WithdrawEvent', msg: $1_Account_WithdrawEvent)
returns (res: $Mutation $1_Event_EventHandle'$1_Account_WithdrawEvent') {
    var handle: $1_Event_EventHandle'$1_Account_WithdrawEvent';
    handle := $Dereference(handle_mut);
    $es := $ExtendEventStore'$1_Account_WithdrawEvent'($es, handle, msg);
    res := handle_mut;
}

procedure {:inline 1} $1_Event_destroy_handle'$1_Account_WithdrawEvent'(handle: $1_Event_EventHandle'$1_Account_WithdrawEvent') {
}

function {:inline} $ExtendEventStore'$1_Account_WithdrawEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_WithdrawEvent', msg: $1_Account_WithdrawEvent): $EventStore {
    (var stream := streams#$EventStore(es)[handle];
    (var stream_new := ExtendMultiset(stream, $ToEventRep'$1_Account_WithdrawEvent'(msg));
    $EventStore(counter#$EventStore(es)+1, streams#$EventStore(es)[handle := stream_new])))
}

function {:inline} $CondExtendEventStore'$1_Account_WithdrawEvent'(
        es: $EventStore, handle: $1_Event_EventHandle'$1_Account_WithdrawEvent', msg: $1_Account_WithdrawEvent, cond: bool): $EventStore {
    if cond then
        $ExtendEventStore'$1_Account_WithdrawEvent'(es, handle, msg)
    else
        es
}




//==================================
// Begin Translation



// Given Types for Type Parameters

type #0;
function {:inline} $IsEqual'#0'(x1: #0, x2: #0): bool { x1 == x2 }
function {:inline} $IsValid'#0'(x: #0): bool { true }

// spec fun at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Vector.move:88:5+86
function {:inline} $1_Vector_$is_empty'$1_Account_WithdrawCapability'(v: Vec ($1_Account_WithdrawCapability)): bool {
    $IsEqual'u64'($1_Vector_$length'$1_Account_WithdrawCapability'(v), 0)
}

// spec fun at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Option.move:53:5+95
function {:inline} $1_Option_$is_none'$1_Account_WithdrawCapability'(t: $1_Option_Option'$1_Account_WithdrawCapability'): bool {
    $1_Vector_$is_empty'$1_Account_WithdrawCapability'($vec#$1_Option_Option'$1_Account_WithdrawCapability'(t))
}

// struct Option::Option<Account::WithdrawCapability> at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Option.move:10:5+77
type {:datatype} $1_Option_Option'$1_Account_WithdrawCapability';
function {:constructor} $1_Option_Option'$1_Account_WithdrawCapability'($vec: Vec ($1_Account_WithdrawCapability)): $1_Option_Option'$1_Account_WithdrawCapability';
function {:inline} $Update'$1_Option_Option'$1_Account_WithdrawCapability''_vec(s: $1_Option_Option'$1_Account_WithdrawCapability', x: Vec ($1_Account_WithdrawCapability)): $1_Option_Option'$1_Account_WithdrawCapability' {
    $1_Option_Option'$1_Account_WithdrawCapability'(x)
}
function $IsValid'$1_Option_Option'$1_Account_WithdrawCapability''(s: $1_Option_Option'$1_Account_WithdrawCapability'): bool {
    $IsValid'vec'$1_Account_WithdrawCapability''($vec#$1_Option_Option'$1_Account_WithdrawCapability'(s))
}
function {:inline} $IsEqual'$1_Option_Option'$1_Account_WithdrawCapability''(s1: $1_Option_Option'$1_Account_WithdrawCapability', s2: $1_Option_Option'$1_Account_WithdrawCapability'): bool {
    $IsEqual'vec'$1_Account_WithdrawCapability''($vec#$1_Option_Option'$1_Account_WithdrawCapability'(s1), $vec#$1_Option_Option'$1_Account_WithdrawCapability'(s2))}

// struct Option::Option<Account::KeyRotationCapability> at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Option.move:10:5+77
type {:datatype} $1_Option_Option'$1_Account_KeyRotationCapability';
function {:constructor} $1_Option_Option'$1_Account_KeyRotationCapability'($vec: Vec ($1_Account_KeyRotationCapability)): $1_Option_Option'$1_Account_KeyRotationCapability';
function {:inline} $Update'$1_Option_Option'$1_Account_KeyRotationCapability''_vec(s: $1_Option_Option'$1_Account_KeyRotationCapability', x: Vec ($1_Account_KeyRotationCapability)): $1_Option_Option'$1_Account_KeyRotationCapability' {
    $1_Option_Option'$1_Account_KeyRotationCapability'(x)
}
function $IsValid'$1_Option_Option'$1_Account_KeyRotationCapability''(s: $1_Option_Option'$1_Account_KeyRotationCapability'): bool {
    $IsValid'vec'$1_Account_KeyRotationCapability''($vec#$1_Option_Option'$1_Account_KeyRotationCapability'(s))
}
function {:inline} $IsEqual'$1_Option_Option'$1_Account_KeyRotationCapability''(s1: $1_Option_Option'$1_Account_KeyRotationCapability', s2: $1_Option_Option'$1_Account_KeyRotationCapability'): bool {
    $IsEqual'vec'$1_Account_KeyRotationCapability''($vec#$1_Option_Option'$1_Account_KeyRotationCapability'(s1), $vec#$1_Option_Option'$1_Account_KeyRotationCapability'(s2))}

// spec fun at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Signer.move:18:5+77
function {:inline} $1_Signer_$address_of(s: $signer): int {
    $1_Signer_$borrow_address(s)
}

// struct Counter::Counter<Counter::Counter<Vesting::MyCounter>> at ./sources/Counter.move:11:5+62
type {:datatype} $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'';
function {:constructor} $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''($value: int): $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'';
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'''_value(s: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'', x: int): $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'' {
    $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''(x)
}
function $IsValid'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'''(s: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''): bool {
    $IsValid'u64'($value#$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''(s))
}
function {:inline} $IsEqual'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'''(s1: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'', s2: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''): bool {
    s1 == s2
}
var $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_$memory: $Memory $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'';

// struct Counter::Counter<Vesting::MyCounter> at ./sources/Counter.move:11:5+62
type {:datatype} $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter';
function {:constructor} $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'($value: int): $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter';
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_value(s: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter', x: int): $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter' {
    $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(x)
}
function $IsValid'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''(s: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'): bool {
    $IsValid'u64'($value#$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(s))
}
function {:inline} $IsEqual'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''(s1: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter', s2: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'): bool {
    s1 == s2
}
var $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory: $Memory $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter';

// fun Counter::has_counter<Counter::Counter<Vesting::MyCounter>> [baseline] at ./sources/Counter.move:63:5+87
procedure {:inline 1} $6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''(_$t0: int) returns ($ret0: bool)
{
    // declare local variables
    var $t1: bool;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'bool': bool;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[addr]($t0) at ./sources/Counter.move:63:5+1
    assume {:print "$at(55,2242,2243)"} true;
    assume {:print "$track_local(4,1,0):", $t0} $t0 == $t0;

    // $t1 := exists<Counter::Counter<#0>>($t0) at ./sources/Counter.move:64:9+6
    assume {:print "$at(55,2299,2305)"} true;
    $t1 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_$memory, $t0);

    // trace_return[0]($t1) at ./sources/Counter.move:64:9+24
    assume {:print "$track_return(4,1,0):", $t1} $t1 == $t1;

    // label L1 at ./sources/Counter.move:65:5+1
    assume {:print "$at(55,2328,2329)"} true;
L1:

    // return $t1 at ./sources/Counter.move:65:5+1
    $ret0 := $t1;
    return;

}

// fun Counter::increment<Vesting::MyCounter> [baseline] at ./sources/Counter.move:27:5+403
procedure {:inline 1} $6ee3f577c8da207830c31e1f0abb4244_Counter_increment'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(_$t0: $signer, _$t1: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter) returns ($ret0: int)
{
    // declare local variables
    var $t2: $Mutation (int);
    var $t3: int;
    var $t4: bool;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: int;
    var $t9: $Mutation ($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter');
    var $t10: $Mutation (int);
    var $t11: int;
    var $t12: int;
    var $t13: bool;
    var $t14: int;
    var $t15: int;
    var $t16: int;
    var $t17: int;
    var $t18: int;
    var $t19: int;
    var $t0: $signer;
    var $t1: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
    var $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter': $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
    var $temp_0'signer': $signer;
    var $temp_0'u64': int;
    $t0 := _$t0;
    $t1 := _$t1;
    assume IsEmptyVec(p#$Mutation($t2));
    assume IsEmptyVec(p#$Mutation($t9));
    assume IsEmptyVec(p#$Mutation($t10));

    // bytecode translation starts here
    // trace_local[account]($t0) at ./sources/Counter.move:27:5+1
    assume {:print "$at(55,848,849)"} true;
    assume {:print "$track_local(4,2,0):", $t0} $t0 == $t0;

    // trace_local[_witness]($t1) at ./sources/Counter.move:27:5+1
    assume {:print "$track_local(4,2,1):", $t1} $t1 == $t1;

    // $t3 := opaque begin: Signer::address_of($t0) at ./sources/Counter.move:28:36+27
    assume {:print "$at(55,963,990)"} true;

    // assume WellFormed($t3) at ./sources/Counter.move:28:36+27
    assume $IsValid'address'($t3);

    // assume Eq<address>($t3, Signer::$address_of($t0)) at ./sources/Counter.move:28:36+27
    assume $IsEqual'address'($t3, $1_Signer_$address_of($t0));

    // $t3 := opaque end: Signer::address_of($t0) at ./sources/Counter.move:28:36+27

    // $t4 := exists<Counter::Counter<#0>>($t3) at ./sources/Counter.move:28:17+6
    $t4 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $t3);

    // if ($t4) goto L0 else goto L1 at ./sources/Counter.move:28:9+98
    if ($t4) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Counter.move:28:9+98
L1:

    // destroy($t0) at ./sources/Counter.move:28:9+98

    // $t5 := 1 at ./sources/Counter.move:28:88+17
    $t5 := 1;
    assume $IsValid'u64'($t5);

    // $t6 := opaque begin: Errors::not_published($t5) at ./sources/Counter.move:28:66+40

    // assume WellFormed($t6) at ./sources/Counter.move:28:66+40
    assume $IsValid'u64'($t6);

    // assume Eq<u64>($t6, 5) at ./sources/Counter.move:28:66+40
    assume $IsEqual'u64'($t6, 5);

    // $t6 := opaque end: Errors::not_published($t5) at ./sources/Counter.move:28:66+40

    // trace_abort($t6) at ./sources/Counter.move:28:9+98
    assume {:print "$at(55,936,1034)"} true;
    assume {:print "$track_abort(4,2):", $t6} $t6 == $t6;

    // $t7 := move($t6) at ./sources/Counter.move:28:9+98
    $t7 := $t6;

    // goto L5 at ./sources/Counter.move:28:9+98
    goto L5;

    // label L0 at ./sources/Counter.move:29:75+7
    assume {:print "$at(55,1110,1117)"} true;
L0:

    // $t8 := opaque begin: Signer::address_of($t0) at ./sources/Counter.move:29:56+27

    // assume WellFormed($t8) at ./sources/Counter.move:29:56+27
    assume $IsValid'address'($t8);

    // assume Eq<address>($t8, Signer::$address_of($t0)) at ./sources/Counter.move:29:56+27
    assume $IsEqual'address'($t8, $1_Signer_$address_of($t0));

    // $t8 := opaque end: Signer::address_of($t0) at ./sources/Counter.move:29:56+27

    // $t9 := borrow_global<Counter::Counter<#0>>($t8) on_abort goto L5 with $t7 at ./sources/Counter.move:29:26+17
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $t8)) {
        call $ExecFailureAbort();
    } else {
        $t9 := $Mutation($Global($t8), EmptyVec(), $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $t8));
    }
    if ($abort_flag) {
        assume {:print "$at(55,1061,1078)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(4,2):", $t7} $t7 == $t7;
        goto L5;
    }

    // $t10 := borrow_field<Counter::Counter<#0>>.value($t9) at ./sources/Counter.move:29:21+69
    $t10 := $ChildMutation($t9, 0, $value#$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'($Dereference($t9)));

    // trace_local[c_ref]($t10) at ./sources/Counter.move:29:13+5
    $temp_0'u64' := $Dereference($t10);
    assume {:print "$track_local(4,2,2):", $temp_0'u64'} $temp_0'u64' == $temp_0'u64';

    // $t11 := read_ref($t10) at ./sources/Counter.move:30:17+6
    assume {:print "$at(55,1143,1149)"} true;
    $t11 := $Dereference($t10);

    // $t12 := 18446744073709551615 at ./sources/Counter.move:30:26+7
    $t12 := 18446744073709551615;
    assume $IsValid'u64'($t12);

    // $t13 := <($t11, $t12) at ./sources/Counter.move:30:24+1
    call $t13 := $Lt($t11, $t12);

    // if ($t13) goto L2 else goto L6 at ./sources/Counter.move:30:9+65
    if ($t13) { goto L2; } else { goto L6; }

    // label L3 at ./sources/Counter.move:30:9+65
L3:

    // destroy($t10) at ./sources/Counter.move:30:9+65

    // $t14 := 2 at ./sources/Counter.move:30:58+14
    $t14 := 2;
    assume $IsValid'u64'($t14);

    // $t15 := opaque begin: Errors::limit_exceeded($t14) at ./sources/Counter.move:30:35+38

    // assume WellFormed($t15) at ./sources/Counter.move:30:35+38
    assume $IsValid'u64'($t15);

    // assume Eq<u64>($t15, 8) at ./sources/Counter.move:30:35+38
    assume $IsEqual'u64'($t15, 8);

    // $t15 := opaque end: Errors::limit_exceeded($t14) at ./sources/Counter.move:30:35+38

    // trace_abort($t15) at ./sources/Counter.move:30:9+65
    assume {:print "$at(55,1135,1200)"} true;
    assume {:print "$track_abort(4,2):", $t15} $t15 == $t15;

    // $t7 := move($t15) at ./sources/Counter.move:30:9+65
    $t7 := $t15;

    // goto L5 at ./sources/Counter.move:30:9+65
    goto L5;

    // label L2 at ./sources/Counter.move:31:19+5
    assume {:print "$at(55,1220,1225)"} true;
L2:

    // $t16 := read_ref($t10) at ./sources/Counter.move:31:18+6
    $t16 := $Dereference($t10);

    // $t17 := 1 at ./sources/Counter.move:31:27+1
    $t17 := 1;
    assume $IsValid'u64'($t17);

    // $t18 := +($t16, $t17) on_abort goto L5 with $t7 at ./sources/Counter.move:31:25+1
    call $t18 := $AddU64($t16, $t17);
    if ($abort_flag) {
        assume {:print "$at(55,1226,1227)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(4,2):", $t7} $t7 == $t7;
        goto L5;
    }

    // write_ref($t10, $t18) at ./sources/Counter.move:31:9+19
    $t10 := $UpdateMutation($t10, $t18);

    // $t19 := read_ref($t10) at ./sources/Counter.move:32:9+6
    assume {:print "$at(55,1239,1245)"} true;
    $t19 := $Dereference($t10);

    // write_back[Reference($t9).value (u64)]($t10) at ./sources/Counter.move:32:9+6
    $t9 := $UpdateMutation($t9, $Update'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_value($Dereference($t9), $Dereference($t10)));

    // write_back[Counter::Counter<#0>@]($t9) at ./sources/Counter.move:32:9+6
    $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory := $ResourceUpdate($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $GlobalLocationAddress($t9),
        $Dereference($t9));

    // trace_return[0]($t19) at ./sources/Counter.move:32:9+6
    assume {:print "$track_return(4,2,0):", $t19} $t19 == $t19;

    // label L4 at ./sources/Counter.move:33:5+1
    assume {:print "$at(55,1250,1251)"} true;
L4:

    // return $t19 at ./sources/Counter.move:33:5+1
    $ret0 := $t19;
    return;

    // label L5 at ./sources/Counter.move:33:5+1
L5:

    // abort($t7) at ./sources/Counter.move:33:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

    // label L6 at <internal>:1:1+10
    assume {:print "$at(1,0,10)"} true;
L6:

    // destroy($t9) at <internal>:1:1+10

    // goto L3 at <internal>:1:1+10
    goto L3;

}

// fun Counter::init<Vesting::MyCounter> [baseline] at ./sources/Counter.move:16:5+204
procedure {:inline 1} $6ee3f577c8da207830c31e1f0abb4244_Counter_init'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(_$t0: $signer) returns ()
{
    // declare local variables
    var $t1: int;
    var $t2: bool;
    var $t3: bool;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter';
    var $t0: $signer;
    var $temp_0'signer': $signer;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[account]($t0) at ./sources/Counter.move:16:5+1
    assume {:print "$at(55,406,407)"} true;
    assume {:print "$track_local(4,3,0):", $t0} $t0 == $t0;

    // $t1 := opaque begin: Signer::address_of($t0) at ./sources/Counter.move:17:37+27
    assume {:print "$at(55,481,508)"} true;

    // assume WellFormed($t1) at ./sources/Counter.move:17:37+27
    assume $IsValid'address'($t1);

    // assume Eq<address>($t1, Signer::$address_of($t0)) at ./sources/Counter.move:17:37+27
    assume $IsEqual'address'($t1, $1_Signer_$address_of($t0));

    // $t1 := opaque end: Signer::address_of($t0) at ./sources/Counter.move:17:37+27

    // $t2 := exists<Counter::Counter<#0>>($t1) at ./sources/Counter.move:17:18+6
    $t2 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $t1);

    // $t3 := !($t2) at ./sources/Counter.move:17:17+1
    call $t3 := $Not($t2);

    // if ($t3) goto L0 else goto L1 at ./sources/Counter.move:17:9+99
    if ($t3) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Counter.move:17:9+99
L1:

    // destroy($t0) at ./sources/Counter.move:17:9+99

    // $t4 := 0 at ./sources/Counter.move:17:93+13
    $t4 := 0;
    assume $IsValid'u64'($t4);

    // $t5 := opaque begin: Errors::already_published($t4) at ./sources/Counter.move:17:67+40

    // assume WellFormed($t5) at ./sources/Counter.move:17:67+40
    assume $IsValid'u64'($t5);

    // assume Eq<u64>($t5, 6) at ./sources/Counter.move:17:67+40
    assume $IsEqual'u64'($t5, 6);

    // $t5 := opaque end: Errors::already_published($t4) at ./sources/Counter.move:17:67+40

    // trace_abort($t5) at ./sources/Counter.move:17:9+99
    assume {:print "$at(55,453,552)"} true;
    assume {:print "$track_abort(4,3):", $t5} $t5 == $t5;

    // $t6 := move($t5) at ./sources/Counter.move:17:9+99
    $t6 := $t5;

    // goto L3 at ./sources/Counter.move:17:9+99
    goto L3;

    // label L0 at ./sources/Counter.move:18:17+7
    assume {:print "$at(55,570,577)"} true;
L0:

    // $t7 := 0 at ./sources/Counter.move:18:46+1
    $t7 := 0;
    assume $IsValid'u64'($t7);

    // $t8 := pack Counter::Counter<#0>($t7) at ./sources/Counter.move:18:26+23
    $t8 := $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'($t7);

    // move_to<Counter::Counter<#0>>($t8, $t0) on_abort goto L3 with $t6 at ./sources/Counter.move:18:9+7
    if ($ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $addr#$signer($t0))) {
        call $ExecFailureAbort();
    } else {
        $6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory := $ResourceUpdate($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $addr#$signer($t0), $t8);
    }
    if ($abort_flag) {
        assume {:print "$at(55,562,569)"} true;
        $t6 := $abort_code;
        assume {:print "$track_abort(4,3):", $t6} $t6 == $t6;
        goto L3;
    }

    // label L2 at ./sources/Counter.move:19:5+1
    assume {:print "$at(55,609,610)"} true;
L2:

    // return () at ./sources/Counter.move:19:5+1
    return;

    // label L3 at ./sources/Counter.move:19:5+1
L3:

    // abort($t6) at ./sources/Counter.move:19:5+1
    $abort_code := $t6;
    $abort_flag := true;
    return;

}

// spec fun at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Math.move:134:10+25
function  $1_Math_spec_mul_div(): int;
axiom (var $$res := $1_Math_spec_mul_div();
$IsValid'u128'($$res));

// struct Token::Token<#0> at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:16:5+70
type {:datatype} $1_Token_Token'#0';
function {:constructor} $1_Token_Token'#0'($value: int): $1_Token_Token'#0';
function {:inline} $Update'$1_Token_Token'#0''_value(s: $1_Token_Token'#0', x: int): $1_Token_Token'#0' {
    $1_Token_Token'#0'(x)
}
function $IsValid'$1_Token_Token'#0''(s: $1_Token_Token'#0'): bool {
    $IsValid'u128'($value#$1_Token_Token'#0'(s))
}
function {:inline} $IsEqual'$1_Token_Token'#0''(s1: $1_Token_Token'#0', s2: $1_Token_Token'#0'): bool {
    s1 == s2
}

// struct Token::TokenCode at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:21:5+338
type {:datatype} $1_Token_TokenCode;
function {:constructor} $1_Token_TokenCode($addr: int, $module_name: Vec (int), $name: Vec (int)): $1_Token_TokenCode;
function {:inline} $Update'$1_Token_TokenCode'_addr(s: $1_Token_TokenCode, x: int): $1_Token_TokenCode {
    $1_Token_TokenCode(x, $module_name#$1_Token_TokenCode(s), $name#$1_Token_TokenCode(s))
}
function {:inline} $Update'$1_Token_TokenCode'_module_name(s: $1_Token_TokenCode, x: Vec (int)): $1_Token_TokenCode {
    $1_Token_TokenCode($addr#$1_Token_TokenCode(s), x, $name#$1_Token_TokenCode(s))
}
function {:inline} $Update'$1_Token_TokenCode'_name(s: $1_Token_TokenCode, x: Vec (int)): $1_Token_TokenCode {
    $1_Token_TokenCode($addr#$1_Token_TokenCode(s), $module_name#$1_Token_TokenCode(s), x)
}
function $IsValid'$1_Token_TokenCode'(s: $1_Token_TokenCode): bool {
    $IsValid'address'($addr#$1_Token_TokenCode(s))
      && $IsValid'vec'u8''($module_name#$1_Token_TokenCode(s))
      && $IsValid'vec'u8''($name#$1_Token_TokenCode(s))
}
function {:inline} $IsEqual'$1_Token_TokenCode'(s1: $1_Token_TokenCode, s2: $1_Token_TokenCode): bool {
    $IsEqual'address'($addr#$1_Token_TokenCode(s1), $addr#$1_Token_TokenCode(s2))
    && $IsEqual'vec'u8''($module_name#$1_Token_TokenCode(s1), $module_name#$1_Token_TokenCode(s2))
    && $IsEqual'vec'u8''($name#$1_Token_TokenCode(s1), $name#$1_Token_TokenCode(s2))}

// fun Token::value<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:328:5+94
procedure {:inline 1} $1_Token_value'#0'(_$t0: $1_Token_Token'#0') returns ($ret0: int)
{
    // declare local variables
    var $t1: int;
    var $t0: $1_Token_Token'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:328:5+1
    assume {:print "$at(54,12400,12401)"} true;
    assume {:print "$track_local(9,28,0):", $t0} $t0 == $t0;

    // $t1 := get_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:329:9+11
    assume {:print "$at(54,12477,12488)"} true;
    $t1 := $value#$1_Token_Token'#0'($t0);

    // trace_return[0]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:329:9+11
    assume {:print "$track_return(9,28,0):", $t1} $t1 == $t1;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:330:5+1
    assume {:print "$at(54,12493,12494)"} true;
L1:

    // return $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:330:5+1
    $ret0 := $t1;
    return;

}

// fun Token::deposit<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:389:5+179
procedure {:inline 1} $1_Token_deposit'#0'(_$t0: $Mutation ($1_Token_Token'#0'), _$t1: $1_Token_Token'#0') returns ($ret0: $Mutation ($1_Token_Token'#0'))
{
    // declare local variables
    var $t2: int;
    var $t3: int;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: $Mutation (int);
    var $t0: $Mutation ($1_Token_Token'#0');
    var $t1: $1_Token_Token'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;
    $t1 := _$t1;
    assume IsEmptyVec(p#$Mutation($t7));

    // bytecode translation starts here
    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:389:5+1
    assume {:print "$at(54,14464,14465)"} true;
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,4,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // trace_local[check]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:389:5+1
    assume {:print "$track_local(9,4,1):", $t1} $t1 == $t1;

    // $t3 := unpack Token::Token<#0>($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:390:13+15
    assume {:print "$at(54,14570,14585)"} true;
    $t3 := $value#$1_Token_Token'#0'($t1);

    // trace_local[value]($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:390:21+5
    assume {:print "$track_local(9,4,2):", $t3} $t3 == $t3;

    // $t4 := get_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:23+11
    assume {:print "$at(54,14617,14628)"} true;
    $t4 := $value#$1_Token_Token'#0'($Dereference($t0));

    // $t5 := +($t4, $t3) on_abort goto L2 with $t6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:35+1
    call $t5 := $AddU128($t4, $t3);
    if ($abort_flag) {
        assume {:print "$at(54,14629,14630)"} true;
        $t6 := $abort_code;
        assume {:print "$track_abort(9,4):", $t6} $t6 == $t6;
        goto L2;
    }

    // $t7 := borrow_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:9+11
    $t7 := $ChildMutation($t0, 0, $value#$1_Token_Token'#0'($Dereference($t0)));

    // write_ref($t7, $t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:9+33
    $t7 := $UpdateMutation($t7, $t5);

    // write_back[Reference($t0).value (u128)]($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:9+33
    $t0 := $UpdateMutation($t0, $Update'$1_Token_Token'#0''_value($Dereference($t0), $Dereference($t7)));

    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:9+33
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,4,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:391:42+1
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,4,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:392:5+1
    assume {:print "$at(54,14642,14643)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:392:5+1
    $ret0 := $t0;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:392:5+1
L2:

    // abort($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:392:5+1
    $abort_code := $t6;
    $abort_flag := true;
    return;

}

// fun Token::destroy_zero<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:403:5+187
procedure {:inline 1} $1_Token_destroy_zero'#0'(_$t0: $1_Token_Token'#0') returns ()
{
    // declare local variables
    var $t1: int;
    var $t2: int;
    var $t3: int;
    var $t4: bool;
    var $t5: int;
    var $t6: int;
    var $t0: $1_Token_Token'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:403:5+1
    assume {:print "$at(54,14993,14994)"} true;
    assume {:print "$track_local(9,8,0):", $t0} $t0 == $t0;

    // $t2 := unpack Token::Token<#0>($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:404:13+15
    assume {:print "$at(54,15074,15089)"} true;
    $t2 := $value#$1_Token_Token'#0'($t0);

    // trace_local[value]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:404:21+5
    assume {:print "$track_local(9,8,1):", $t2} $t2 == $t2;

    // $t3 := 0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:26+1
    assume {:print "$at(54,15124,15125)"} true;
    $t3 := 0;
    assume $IsValid'u128'($t3);

    // $t4 := ==($t2, $t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:23+2
    $t4 := $IsEqual'u128'($t2, $t3);

    // if ($t4) goto L0 else goto L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:9+67
    if ($t4) { goto L0; } else { goto L1; }

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:51+23
L1:

    // $t5 := 16 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:51+23
    $t5 := 16;
    assume $IsValid'u64'($t5);

    // $t6 := opaque begin: Errors::invalid_state($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:29+46

    // assume WellFormed($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:29+46
    assume $IsValid'u64'($t6);

    // assume Eq<u64>($t6, 1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:29+46
    assume $IsEqual'u64'($t6, 1);

    // $t6 := opaque end: Errors::invalid_state($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:29+46

    // trace_abort($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:9+67
    assume {:print "$at(54,15107,15174)"} true;
    assume {:print "$track_abort(9,8):", $t6} $t6 == $t6;

    // goto L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:9+67
    goto L3;

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:405:9+67
L0:

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:406:5+1
    assume {:print "$at(54,15179,15180)"} true;
L2:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:406:5+1
    return;

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:406:5+1
L3:

    // abort($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:406:5+1
    $abort_code := $t6;
    $abort_flag := true;
    return;

}

// fun Token::withdraw<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:354:5+355
procedure {:inline 1} $1_Token_withdraw'#0'(_$t0: $Mutation ($1_Token_Token'#0'), _$t1: int) returns ($ret0: $1_Token_Token'#0', $ret1: $Mutation ($1_Token_Token'#0'))
{
    // declare local variables
    var $t2: int;
    var $t3: bool;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: int;
    var $t9: $Mutation (int);
    var $t10: $1_Token_Token'#0';
    var $t0: $Mutation ($1_Token_Token'#0');
    var $t1: int;
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;
    $t1 := _$t1;
    assume IsEmptyVec(p#$Mutation($t9));

    // bytecode translation starts here
    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:354:5+1
    assume {:print "$at(54,13228,13229)"} true;
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,29,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // trace_local[value]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:354:5+1
    assume {:print "$track_local(9,29,1):", $t1} $t1 == $t1;

    // $t2 := get_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:17+11
    assume {:print "$at(54,13429,13440)"} true;
    $t2 := $value#$1_Token_Token'#0'($Dereference($t0));

    // $t3 := >=($t2, $t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:29+2
    call $t3 := $Ge($t2, $t1);

    // if ($t3) goto L0 else goto L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81
    if ($t3) { goto L0; } else { goto L1; }

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81
L1:

    // destroy($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81

    // $t4 := 102 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:62+26
    $t4 := 102;
    assume $IsValid'u64'($t4);

    // $t5 := opaque begin: Errors::limit_exceeded($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:39+50

    // assume WellFormed($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:39+50
    assume $IsValid'u64'($t5);

    // assume Eq<u64>($t5, 8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:39+50
    assume $IsEqual'u64'($t5, 8);

    // $t5 := opaque end: Errors::limit_exceeded($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:39+50

    // trace_abort($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81
    assume {:print "$at(54,13421,13502)"} true;
    assume {:print "$track_abort(9,29):", $t5} $t5 == $t5;

    // $t6 := move($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81
    $t6 := $t5;

    // goto L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:359:9+81
    goto L3;

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:23+5
    assume {:print "$at(54,13526,13531)"} true;
L0:

    // $t7 := get_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:23+11
    $t7 := $value#$1_Token_Token'#0'($Dereference($t0));

    // $t8 := -($t7, $t1) on_abort goto L3 with $t6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:35+1
    call $t8 := $Sub($t7, $t1);
    if ($abort_flag) {
        assume {:print "$at(54,13538,13539)"} true;
        $t6 := $abort_code;
        assume {:print "$track_abort(9,29):", $t6} $t6 == $t6;
        goto L3;
    }

    // $t9 := borrow_field<Token::Token<#0>>.value($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:9+11
    $t9 := $ChildMutation($t0, 0, $value#$1_Token_Token'#0'($Dereference($t0)));

    // write_ref($t9, $t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:9+33
    $t9 := $UpdateMutation($t9, $t8);

    // write_back[Reference($t0).value (u128)]($t9) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:9+33
    $t0 := $UpdateMutation($t0, $Update'$1_Token_Token'#0''_value($Dereference($t0), $Dereference($t9)));

    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:360:9+33
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,29,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // $t10 := pack Token::Token<#0>($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:361:9+22
    assume {:print "$at(54,13555,13577)"} true;
    $t10 := $1_Token_Token'#0'($t1);

    // trace_return[0]($t10) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:361:9+22
    assume {:print "$track_return(9,29,0):", $t10} $t10 == $t10;

    // trace_local[token]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:361:9+22
    $temp_0'$1_Token_Token'#0'' := $Dereference($t0);
    assume {:print "$track_local(9,29,0):", $temp_0'$1_Token_Token'#0''} $temp_0'$1_Token_Token'#0'' == $temp_0'$1_Token_Token'#0'';

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:362:5+1
    assume {:print "$at(54,13582,13583)"} true;
L2:

    // return $t10 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:362:5+1
    $ret0 := $t10;
    $ret1 := $t0;
    return;

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:362:5+1
L3:

    // abort($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:362:5+1
    $abort_code := $t6;
    $abort_flag := true;
    return;

}

// fun Token::zero<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:319:5+99
procedure {:inline 1} $1_Token_zero'#0'() returns ($ret0: $1_Token_Token'#0')
{
    // declare local variables
    var $t0: int;
    var $t1: $1_Token_Token'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';

    // bytecode translation starts here
    // $t0 := 0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:320:35+1
    assume {:print "$at(54,12312,12313)"} true;
    $t0 := 0;
    assume $IsValid'u128'($t0);

    // $t1 := pack Token::Token<#0>($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:320:9+29
    $t1 := $1_Token_Token'#0'($t0);

    // trace_return[0]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:320:9+29
    assume {:print "$track_return(9,30,0):", $t1} $t1 == $t1;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:321:5+1
    assume {:print "$at(54,12320,12321)"} true;
L1:

    // return $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Token.move:321:5+1
    $ret0 := $t1;
    return;

}

// fun CoreAddresses::GENESIS_ADDRESS [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/CoreAddresses.move:15:5+58
procedure {:inline 1} $1_CoreAddresses_GENESIS_ADDRESS() returns ($ret0: int)
{
    // declare local variables
    var $t0: int;
    var $temp_0'address': int;

    // bytecode translation starts here
    // $t0 := 0x1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/CoreAddresses.move:16:9+4
    assume {:print "$at(11,389,393)"} true;
    $t0 := 1;
    assume $IsValid'address'($t0);

    // trace_return[0]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/CoreAddresses.move:16:9+4
    assume {:print "$track_return(10,1,0):", $t0} $t0 == $t0;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/CoreAddresses.move:17:5+1
    assume {:print "$at(11,398,399)"} true;
L1:

    // return $t0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/CoreAddresses.move:17:5+1
    $ret0 := $t0;
    return;

}

// struct Timestamp::CurrentTimeMilliseconds at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:16:5+73
type {:datatype} $1_Timestamp_CurrentTimeMilliseconds;
function {:constructor} $1_Timestamp_CurrentTimeMilliseconds($milliseconds: int): $1_Timestamp_CurrentTimeMilliseconds;
function {:inline} $Update'$1_Timestamp_CurrentTimeMilliseconds'_milliseconds(s: $1_Timestamp_CurrentTimeMilliseconds, x: int): $1_Timestamp_CurrentTimeMilliseconds {
    $1_Timestamp_CurrentTimeMilliseconds(x)
}
function $IsValid'$1_Timestamp_CurrentTimeMilliseconds'(s: $1_Timestamp_CurrentTimeMilliseconds): bool {
    $IsValid'u64'($milliseconds#$1_Timestamp_CurrentTimeMilliseconds(s))
}
function {:inline} $IsEqual'$1_Timestamp_CurrentTimeMilliseconds'(s1: $1_Timestamp_CurrentTimeMilliseconds, s2: $1_Timestamp_CurrentTimeMilliseconds): bool {
    s1 == s2
}
var $1_Timestamp_CurrentTimeMilliseconds_$memory: $Memory $1_Timestamp_CurrentTimeMilliseconds;

// fun Timestamp::now_milliseconds [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:71:5+169
procedure {:inline 1} $1_Timestamp_now_milliseconds() returns ($ret0: int)
{
    // declare local variables
    var $t0: int;
    var $t1: int;
    var $t2: $1_Timestamp_CurrentTimeMilliseconds;
    var $t3: int;
    var $temp_0'u64': int;

    // bytecode translation starts here
    // $t0 := CoreAddresses::GENESIS_ADDRESS() on_abort goto L2 with $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:72:48+32
    assume {:print "$at(82,3342,3374)"} true;
    call $t0 := $1_CoreAddresses_GENESIS_ADDRESS();
    if ($abort_flag) {
        assume {:print "$at(82,3342,3374)"} true;
        $t1 := $abort_code;
        assume {:print "$track_abort(11,3):", $t1} $t1 == $t1;
        goto L2;
    }

    // $t2 := get_global<Timestamp::CurrentTimeMilliseconds>($t0) on_abort goto L2 with $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:72:9+13
    if (!$ResourceExists($1_Timestamp_CurrentTimeMilliseconds_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t2 := $ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(82,3303,3316)"} true;
        $t1 := $abort_code;
        assume {:print "$track_abort(11,3):", $t1} $t1 == $t1;
        goto L2;
    }

    // $t3 := get_field<Timestamp::CurrentTimeMilliseconds>.milliseconds($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:72:9+85
    $t3 := $milliseconds#$1_Timestamp_CurrentTimeMilliseconds($t2);

    // trace_return[0]($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:72:9+85
    assume {:print "$track_return(11,3,0):", $t3} $t3 == $t3;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:73:5+1
    assume {:print "$at(82,3393,3394)"} true;
L1:

    // return $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:73:5+1
    $ret0 := $t3;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:73:5+1
L2:

    // abort($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Timestamp.move:73:5+1
    $abort_code := $t1;
    $abort_flag := true;
    return;

}

// struct Account::DepositEvent at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:83:5+286
type {:datatype} $1_Account_DepositEvent;
function {:constructor} $1_Account_DepositEvent($amount: int, $token_code: $1_Token_TokenCode, $metadata: Vec (int)): $1_Account_DepositEvent;
function {:inline} $Update'$1_Account_DepositEvent'_amount(s: $1_Account_DepositEvent, x: int): $1_Account_DepositEvent {
    $1_Account_DepositEvent(x, $token_code#$1_Account_DepositEvent(s), $metadata#$1_Account_DepositEvent(s))
}
function {:inline} $Update'$1_Account_DepositEvent'_token_code(s: $1_Account_DepositEvent, x: $1_Token_TokenCode): $1_Account_DepositEvent {
    $1_Account_DepositEvent($amount#$1_Account_DepositEvent(s), x, $metadata#$1_Account_DepositEvent(s))
}
function {:inline} $Update'$1_Account_DepositEvent'_metadata(s: $1_Account_DepositEvent, x: Vec (int)): $1_Account_DepositEvent {
    $1_Account_DepositEvent($amount#$1_Account_DepositEvent(s), $token_code#$1_Account_DepositEvent(s), x)
}
function $IsValid'$1_Account_DepositEvent'(s: $1_Account_DepositEvent): bool {
    $IsValid'u128'($amount#$1_Account_DepositEvent(s))
      && $IsValid'$1_Token_TokenCode'($token_code#$1_Account_DepositEvent(s))
      && $IsValid'vec'u8''($metadata#$1_Account_DepositEvent(s))
}
function {:inline} $IsEqual'$1_Account_DepositEvent'(s1: $1_Account_DepositEvent, s2: $1_Account_DepositEvent): bool {
    $IsEqual'u128'($amount#$1_Account_DepositEvent(s1), $amount#$1_Account_DepositEvent(s2))
    && $IsEqual'$1_Token_TokenCode'($token_code#$1_Account_DepositEvent(s1), $token_code#$1_Account_DepositEvent(s2))
    && $IsEqual'vec'u8''($metadata#$1_Account_DepositEvent(s1), $metadata#$1_Account_DepositEvent(s2))}

// struct Account::WithdrawCapability at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:62:5+77
type {:datatype} $1_Account_WithdrawCapability;
function {:constructor} $1_Account_WithdrawCapability($account_address: int): $1_Account_WithdrawCapability;
function {:inline} $Update'$1_Account_WithdrawCapability'_account_address(s: $1_Account_WithdrawCapability, x: int): $1_Account_WithdrawCapability {
    $1_Account_WithdrawCapability(x)
}
function $IsValid'$1_Account_WithdrawCapability'(s: $1_Account_WithdrawCapability): bool {
    $IsValid'address'($account_address#$1_Account_WithdrawCapability(s))
}
function {:inline} $IsEqual'$1_Account_WithdrawCapability'(s1: $1_Account_WithdrawCapability, s2: $1_Account_WithdrawCapability): bool {
    s1 == s2
}

// struct Account::WithdrawEvent at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:74:5+288
type {:datatype} $1_Account_WithdrawEvent;
function {:constructor} $1_Account_WithdrawEvent($amount: int, $token_code: $1_Token_TokenCode, $metadata: Vec (int)): $1_Account_WithdrawEvent;
function {:inline} $Update'$1_Account_WithdrawEvent'_amount(s: $1_Account_WithdrawEvent, x: int): $1_Account_WithdrawEvent {
    $1_Account_WithdrawEvent(x, $token_code#$1_Account_WithdrawEvent(s), $metadata#$1_Account_WithdrawEvent(s))
}
function {:inline} $Update'$1_Account_WithdrawEvent'_token_code(s: $1_Account_WithdrawEvent, x: $1_Token_TokenCode): $1_Account_WithdrawEvent {
    $1_Account_WithdrawEvent($amount#$1_Account_WithdrawEvent(s), x, $metadata#$1_Account_WithdrawEvent(s))
}
function {:inline} $Update'$1_Account_WithdrawEvent'_metadata(s: $1_Account_WithdrawEvent, x: Vec (int)): $1_Account_WithdrawEvent {
    $1_Account_WithdrawEvent($amount#$1_Account_WithdrawEvent(s), $token_code#$1_Account_WithdrawEvent(s), x)
}
function $IsValid'$1_Account_WithdrawEvent'(s: $1_Account_WithdrawEvent): bool {
    $IsValid'u128'($amount#$1_Account_WithdrawEvent(s))
      && $IsValid'$1_Token_TokenCode'($token_code#$1_Account_WithdrawEvent(s))
      && $IsValid'vec'u8''($metadata#$1_Account_WithdrawEvent(s))
}
function {:inline} $IsEqual'$1_Account_WithdrawEvent'(s1: $1_Account_WithdrawEvent, s2: $1_Account_WithdrawEvent): bool {
    $IsEqual'u128'($amount#$1_Account_WithdrawEvent(s1), $amount#$1_Account_WithdrawEvent(s2))
    && $IsEqual'$1_Token_TokenCode'($token_code#$1_Account_WithdrawEvent(s1), $token_code#$1_Account_WithdrawEvent(s2))
    && $IsEqual'vec'u8''($metadata#$1_Account_WithdrawEvent(s1), $metadata#$1_Account_WithdrawEvent(s2))}

// struct Account::Account at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:24:5+1590
type {:datatype} $1_Account_Account;
function {:constructor} $1_Account_Account($authentication_key: Vec (int), $withdrawal_capability: $1_Option_Option'$1_Account_WithdrawCapability', $key_rotation_capability: $1_Option_Option'$1_Account_KeyRotationCapability', $withdraw_events: $1_Event_EventHandle'$1_Account_WithdrawEvent', $deposit_events: $1_Event_EventHandle'$1_Account_DepositEvent', $accept_token_events: $1_Event_EventHandle'$1_Account_AcceptTokenEvent', $sequence_number: int): $1_Account_Account;
function {:inline} $Update'$1_Account_Account'_authentication_key(s: $1_Account_Account, x: Vec (int)): $1_Account_Account {
    $1_Account_Account(x, $withdrawal_capability#$1_Account_Account(s), $key_rotation_capability#$1_Account_Account(s), $withdraw_events#$1_Account_Account(s), $deposit_events#$1_Account_Account(s), $accept_token_events#$1_Account_Account(s), $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_withdrawal_capability(s: $1_Account_Account, x: $1_Option_Option'$1_Account_WithdrawCapability'): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), x, $key_rotation_capability#$1_Account_Account(s), $withdraw_events#$1_Account_Account(s), $deposit_events#$1_Account_Account(s), $accept_token_events#$1_Account_Account(s), $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_key_rotation_capability(s: $1_Account_Account, x: $1_Option_Option'$1_Account_KeyRotationCapability'): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), $withdrawal_capability#$1_Account_Account(s), x, $withdraw_events#$1_Account_Account(s), $deposit_events#$1_Account_Account(s), $accept_token_events#$1_Account_Account(s), $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_withdraw_events(s: $1_Account_Account, x: $1_Event_EventHandle'$1_Account_WithdrawEvent'): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), $withdrawal_capability#$1_Account_Account(s), $key_rotation_capability#$1_Account_Account(s), x, $deposit_events#$1_Account_Account(s), $accept_token_events#$1_Account_Account(s), $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_deposit_events(s: $1_Account_Account, x: $1_Event_EventHandle'$1_Account_DepositEvent'): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), $withdrawal_capability#$1_Account_Account(s), $key_rotation_capability#$1_Account_Account(s), $withdraw_events#$1_Account_Account(s), x, $accept_token_events#$1_Account_Account(s), $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_accept_token_events(s: $1_Account_Account, x: $1_Event_EventHandle'$1_Account_AcceptTokenEvent'): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), $withdrawal_capability#$1_Account_Account(s), $key_rotation_capability#$1_Account_Account(s), $withdraw_events#$1_Account_Account(s), $deposit_events#$1_Account_Account(s), x, $sequence_number#$1_Account_Account(s))
}
function {:inline} $Update'$1_Account_Account'_sequence_number(s: $1_Account_Account, x: int): $1_Account_Account {
    $1_Account_Account($authentication_key#$1_Account_Account(s), $withdrawal_capability#$1_Account_Account(s), $key_rotation_capability#$1_Account_Account(s), $withdraw_events#$1_Account_Account(s), $deposit_events#$1_Account_Account(s), $accept_token_events#$1_Account_Account(s), x)
}
function $IsValid'$1_Account_Account'(s: $1_Account_Account): bool {
    $IsValid'vec'u8''($authentication_key#$1_Account_Account(s))
      && $IsValid'$1_Option_Option'$1_Account_WithdrawCapability''($withdrawal_capability#$1_Account_Account(s))
      && $IsValid'$1_Option_Option'$1_Account_KeyRotationCapability''($key_rotation_capability#$1_Account_Account(s))
      && $IsValid'$1_Event_EventHandle'$1_Account_WithdrawEvent''($withdraw_events#$1_Account_Account(s))
      && $IsValid'$1_Event_EventHandle'$1_Account_DepositEvent''($deposit_events#$1_Account_Account(s))
      && $IsValid'$1_Event_EventHandle'$1_Account_AcceptTokenEvent''($accept_token_events#$1_Account_Account(s))
      && $IsValid'u64'($sequence_number#$1_Account_Account(s))
}
function {:inline} $IsEqual'$1_Account_Account'(s1: $1_Account_Account, s2: $1_Account_Account): bool {
    $IsEqual'vec'u8''($authentication_key#$1_Account_Account(s1), $authentication_key#$1_Account_Account(s2))
    && $IsEqual'$1_Option_Option'$1_Account_WithdrawCapability''($withdrawal_capability#$1_Account_Account(s1), $withdrawal_capability#$1_Account_Account(s2))
    && $IsEqual'$1_Option_Option'$1_Account_KeyRotationCapability''($key_rotation_capability#$1_Account_Account(s1), $key_rotation_capability#$1_Account_Account(s2))
    && $IsEqual'$1_Event_EventHandle'$1_Account_WithdrawEvent''($withdraw_events#$1_Account_Account(s1), $withdraw_events#$1_Account_Account(s2))
    && $IsEqual'$1_Event_EventHandle'$1_Account_DepositEvent''($deposit_events#$1_Account_Account(s1), $deposit_events#$1_Account_Account(s2))
    && $IsEqual'$1_Event_EventHandle'$1_Account_AcceptTokenEvent''($accept_token_events#$1_Account_Account(s1), $accept_token_events#$1_Account_Account(s2))
    && $IsEqual'u64'($sequence_number#$1_Account_Account(s1), $sequence_number#$1_Account_Account(s2))}
var $1_Account_Account_$memory: $Memory $1_Account_Account;

// struct Account::AcceptTokenEvent at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:93:5+85
type {:datatype} $1_Account_AcceptTokenEvent;
function {:constructor} $1_Account_AcceptTokenEvent($token_code: $1_Token_TokenCode): $1_Account_AcceptTokenEvent;
function {:inline} $Update'$1_Account_AcceptTokenEvent'_token_code(s: $1_Account_AcceptTokenEvent, x: $1_Token_TokenCode): $1_Account_AcceptTokenEvent {
    $1_Account_AcceptTokenEvent(x)
}
function $IsValid'$1_Account_AcceptTokenEvent'(s: $1_Account_AcceptTokenEvent): bool {
    $IsValid'$1_Token_TokenCode'($token_code#$1_Account_AcceptTokenEvent(s))
}
function {:inline} $IsEqual'$1_Account_AcceptTokenEvent'(s1: $1_Account_AcceptTokenEvent, s2: $1_Account_AcceptTokenEvent): bool {
    $IsEqual'$1_Token_TokenCode'($token_code#$1_Account_AcceptTokenEvent(s1), $token_code#$1_Account_AcceptTokenEvent(s2))}

// struct Account::AutoAcceptToken at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:104:5+47
type {:datatype} $1_Account_AutoAcceptToken;
function {:constructor} $1_Account_AutoAcceptToken($enable: bool): $1_Account_AutoAcceptToken;
function {:inline} $Update'$1_Account_AutoAcceptToken'_enable(s: $1_Account_AutoAcceptToken, x: bool): $1_Account_AutoAcceptToken {
    $1_Account_AutoAcceptToken(x)
}
function $IsValid'$1_Account_AutoAcceptToken'(s: $1_Account_AutoAcceptToken): bool {
    $IsValid'bool'($enable#$1_Account_AutoAcceptToken(s))
}
function {:inline} $IsEqual'$1_Account_AutoAcceptToken'(s1: $1_Account_AutoAcceptToken, s2: $1_Account_AutoAcceptToken): bool {
    s1 == s2
}
var $1_Account_AutoAcceptToken_$memory: $Memory $1_Account_AutoAcceptToken;

// struct Account::Balance<#0> at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:55:5+82
type {:datatype} $1_Account_Balance'#0';
function {:constructor} $1_Account_Balance'#0'($token: $1_Token_Token'#0'): $1_Account_Balance'#0';
function {:inline} $Update'$1_Account_Balance'#0''_token(s: $1_Account_Balance'#0', x: $1_Token_Token'#0'): $1_Account_Balance'#0' {
    $1_Account_Balance'#0'(x)
}
function $IsValid'$1_Account_Balance'#0''(s: $1_Account_Balance'#0'): bool {
    $IsValid'$1_Token_Token'#0''($token#$1_Account_Balance'#0'(s))
}
function {:inline} $IsEqual'$1_Account_Balance'#0''(s1: $1_Account_Balance'#0', s2: $1_Account_Balance'#0'): bool {
    s1 == s2
}
var $1_Account_Balance'#0'_$memory: $Memory $1_Account_Balance'#0';

// struct Account::KeyRotationCapability at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:69:5+80
type {:datatype} $1_Account_KeyRotationCapability;
function {:constructor} $1_Account_KeyRotationCapability($account_address: int): $1_Account_KeyRotationCapability;
function {:inline} $Update'$1_Account_KeyRotationCapability'_account_address(s: $1_Account_KeyRotationCapability, x: int): $1_Account_KeyRotationCapability {
    $1_Account_KeyRotationCapability(x)
}
function $IsValid'$1_Account_KeyRotationCapability'(s: $1_Account_KeyRotationCapability): bool {
    $IsValid'address'($account_address#$1_Account_KeyRotationCapability(s))
}
function {:inline} $IsEqual'$1_Account_KeyRotationCapability'(s1: $1_Account_KeyRotationCapability, s2: $1_Account_KeyRotationCapability): bool {
    s1 == s2
}

// fun Account::deposit<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:302:5+227
procedure {:inline 1} $1_Account_deposit'#0'(_$t0: int, _$t1: $1_Token_Token'#0') returns ()
{
    // declare local variables
    var $t2: Vec (int);
    var $t3: int;
    var $t0: int;
    var $t1: $1_Token_Token'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'address': int;
    $t0 := _$t0;
    $t1 := _$t1;

    // bytecode translation starts here
    // trace_local[receiver]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:302:5+1
    assume {:print "$at(80,12600,12601)"} true;
    assume {:print "$track_local(29,14,0):", $t0} $t0 == $t0;

    // trace_local[to_deposit]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:302:5+1
    assume {:print "$track_local(29,14,1):", $t1} $t1 == $t1;

    // $t2 := [] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:306:64+3
    assume {:print "$at(80,12817,12820)"} true;
    $t2 := $EmptyVec'u8'();
    assume $IsValid'vec'u8''($t2);

    // Account::deposit_with_metadata<#0>($t0, $t1, $t2) on_abort goto L2 with $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:306:9+59
    call $1_Account_deposit_with_metadata'#0'($t0, $t1, $t2);
    if ($abort_flag) {
        assume {:print "$at(80,12762,12821)"} true;
        $t3 := $abort_code;
        assume {:print "$track_abort(29,14):", $t3} $t3 == $t3;
        goto L2;
    }

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:307:5+1
    assume {:print "$at(80,12826,12827)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:307:5+1
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:307:5+1
L2:

    // abort($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:307:5+1
    $abort_code := $t3;
    $abort_flag := true;
    return;

}

// fun Account::withdraw<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:373:5+189
procedure {:inline 1} $1_Account_withdraw'#0'(_$t0: $signer, _$t1: int) returns ($ret0: $1_Token_Token'#0')
{
    // declare local variables
    var $t2: Vec (int);
    var $t3: $1_Token_Token'#0';
    var $t4: int;
    var $t0: $signer;
    var $t1: int;
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'signer': $signer;
    var $temp_0'u128': int;
    $t0 := _$t0;
    $t1 := _$t1;

    // bytecode translation starts here
    // trace_local[account]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:373:5+1
    assume {:print "$at(80,15221,15222)"} true;
    assume {:print "$track_local(29,49,0):", $t0} $t0 == $t0;

    // trace_local[amount]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:373:5+1
    assume {:print "$track_local(29,49,1):", $t1} $t1 == $t1;

    // $t2 := [] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:375:60+3
    assume {:print "$at(80,15400,15403)"} true;
    $t2 := $EmptyVec'u8'();
    assume $IsValid'vec'u8''($t2);

    // $t3 := Account::withdraw_with_metadata<#0>($t0, $t1, $t2) on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:375:9+55
    call $t3 := $1_Account_withdraw_with_metadata'#0'($t0, $t1, $t2);
    if ($abort_flag) {
        assume {:print "$at(80,15349,15404)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,49):", $t4} $t4 == $t4;
        goto L2;
    }

    // trace_return[0]($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:375:9+55
    assume {:print "$track_return(29,49,0):", $t3} $t3 == $t3;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:376:5+1
    assume {:print "$at(80,15409,15410)"} true;
L1:

    // return $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:376:5+1
    $ret0 := $t3;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:376:5+1
L2:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:376:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::balance<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:665:5+240
procedure {:inline 1} $1_Account_balance'#0'(_$t0: int) returns ($ret0: int)
{
    // declare local variables
    var $t1: int;
    var $t2: bool;
    var $t3: $1_Account_Balance'#0';
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'u128': int;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[addr]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:665:5+1
    assume {:print "$at(80,28526,28527)"} true;
    assume {:print "$track_local(29,2,0):", $t0} $t0 == $t0;

    // $t2 := exists<Account::Balance<#0>>($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:13+6
    assume {:print "$at(80,28615,28621)"} true;
    $t2 := $ResourceExists($1_Account_Balance'#0'_$memory, $t0);

    // if ($t2) goto L0 else goto L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    if ($t2) { goto L0; } else { goto L2; }

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:667:59+4
    assume {:print "$at(80,28709,28713)"} true;
L0:

    // $t3 := get_global<Account::Balance<#0>>($t0) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:667:25+13
    if (!$ResourceExists($1_Account_Balance'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t3 := $ResourceValue($1_Account_Balance'#0'_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(80,28675,28688)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,2):", $t4} $t4 == $t4;
        goto L5;
    }

    // $t5 := Account::balance_for<#0>($t3) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:667:13+52
    call $t5 := $1_Account_balance_for'#0'($t3);
    if ($abort_flag) {
        assume {:print "$at(80,28663,28715)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,2):", $t4} $t4 == $t4;
        goto L5;
    }

    // $t1 := $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    assume {:print "$at(80,28611,28760)"} true;
    $t1 := $t5;

    // trace_local[tmp#$1]($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    assume {:print "$track_local(29,2,1):", $t5} $t5 == $t5;

    // goto L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    goto L3;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:669:13+5
    assume {:print "$at(80,28745,28750)"} true;
L2:

    // $t6 := 0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:669:13+5
    $t6 := 0;
    assume $IsValid'u128'($t6);

    // $t1 := $t6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    assume {:print "$at(80,28611,28760)"} true;
    $t1 := $t6;

    // trace_local[tmp#$1]($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    assume {:print "$track_local(29,2,1):", $t6} $t6 == $t6;

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
L3:

    // trace_return[0]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:666:9+149
    assume {:print "$track_return(29,2,0):", $t1} $t1 == $t1;

    // label L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:671:5+1
    assume {:print "$at(80,28765,28766)"} true;
L4:

    // return $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:671:5+1
    $ret0 := $t1;
    return;

    // label L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:671:5+1
L5:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:671:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::balance_for<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:656:5+125
procedure {:inline 1} $1_Account_balance_for'#0'(_$t0: $1_Account_Balance'#0') returns ($ret0: int)
{
    // declare local variables
    var $t1: $1_Token_Token'#0';
    var $t2: int;
    var $t3: int;
    var $t0: $1_Account_Balance'#0';
    var $temp_0'$1_Account_Balance'#0'': $1_Account_Balance'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:656:5+1
    assume {:print "$at(80,28269,28270)"} true;
    assume {:print "$track_local(29,3,0):", $t0} $t0 == $t0;

    // $t1 := get_field<Account::Balance<#0>>.token($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:657:33+14
    assume {:print "$at(80,28373,28387)"} true;
    $t1 := $token#$1_Account_Balance'#0'($t0);

    // $t2 := Token::value<#0>($t1) on_abort goto L2 with $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:657:9+39
    call $t2 := $1_Token_value'#0'($t1);
    if ($abort_flag) {
        assume {:print "$at(80,28349,28388)"} true;
        $t3 := $abort_code;
        assume {:print "$track_abort(29,3):", $t3} $t3 == $t3;
        goto L2;
    }

    // trace_return[0]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:657:9+39
    assume {:print "$track_return(29,3,0):", $t2} $t2 == $t2;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:658:5+1
    assume {:print "$at(80,28393,28394)"} true;
L1:

    // return $t2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:658:5+1
    $ret0 := $t2;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:658:5+1
L2:

    // abort($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:658:5+1
    $abort_code := $t3;
    $abort_flag := true;
    return;

}

// fun Account::can_auto_accept_token [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:725:5+232
procedure {:inline 1} $1_Account_can_auto_accept_token(_$t0: int) returns ($ret0: bool)
{
    // declare local variables
    var $t1: bool;
    var $t2: bool;
    var $t3: $1_Account_AutoAcceptToken;
    var $t4: int;
    var $t5: bool;
    var $t6: bool;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'bool': bool;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[addr]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:725:5+1
    assume {:print "$at(80,30479,30480)"} true;
    assume {:print "$track_local(29,4,0):", $t0} $t0 == $t0;

    // $t2 := exists<Account::AutoAcceptToken>($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:13+6
    assume {:print "$at(80,30572,30578)"} true;
    $t2 := $ResourceExists($1_Account_AutoAcceptToken_$memory, $t0);

    // if ($t2) goto L0 else goto L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    if ($t2) { goto L0; } else { goto L2; }

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:727:44+4
    assume {:print "$at(80,30648,30652)"} true;
L0:

    // $t3 := get_global<Account::AutoAcceptToken>($t0) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:727:13+13
    if (!$ResourceExists($1_Account_AutoAcceptToken_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t3 := $ResourceValue($1_Account_AutoAcceptToken_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(80,30617,30630)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,4):", $t4} $t4 == $t4;
        goto L5;
    }

    // $t5 := get_field<Account::AutoAcceptToken>.enable($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:727:13+43
    $t5 := $enable#$1_Account_AutoAcceptToken($t3);

    // $t1 := $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    assume {:print "$at(80,30568,30705)"} true;
    $t1 := $t5;

    // trace_local[tmp#$1]($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    assume {:print "$track_local(29,4,1):", $t5} $t5 == $t5;

    // goto L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    goto L3;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:729:13+5
    assume {:print "$at(80,30690,30695)"} true;
L2:

    // $t6 := false at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:729:13+5
    $t6 := false;
    assume $IsValid'bool'($t6);

    // $t1 := $t6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    assume {:print "$at(80,30568,30705)"} true;
    $t1 := $t6;

    // trace_local[tmp#$1]($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    assume {:print "$track_local(29,4,1):", $t6} $t6 == $t6;

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
L3:

    // trace_return[0]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:726:9+137
    assume {:print "$track_return(29,4,0):", $t1} $t1 == $t1;

    // label L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:731:5+1
    assume {:print "$at(80,30710,30711)"} true;
L4:

    // return $t1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:731:5+1
    $ret0 := $t1;
    return;

    // label L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:731:5+1
L5:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:731:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::delegated_withdraw_capability [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:800:5+167
procedure {:inline 1} $1_Account_delegated_withdraw_capability(_$t0: int) returns ($ret0: bool)
{
    // declare local variables
    var $t1: $1_Account_Account;
    var $t2: int;
    var $t3: $1_Option_Option'$1_Account_WithdrawCapability';
    var $t4: bool;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'bool': bool;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[addr]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:800:5+1
    assume {:print "$at(80,32944,32945)"} true;
    assume {:print "$track_local(29,13,0):", $t0} $t0 == $t0;

    // $t1 := get_global<Account::Account>($t0) on_abort goto L2 with $t2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:26+13
    assume {:print "$at(80,33054,33067)"} true;
    if (!$ResourceExists($1_Account_Account_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t1 := $ResourceValue($1_Account_Account_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(80,33054,33067)"} true;
        $t2 := $abort_code;
        assume {:print "$track_abort(29,13):", $t2} $t2 == $t2;
        goto L2;
    }

    // $t3 := get_field<Account::Account>.withdrawal_capability($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:25+51
    $t3 := $withdrawal_capability#$1_Account_Account($t1);

    // $t4 := opaque begin: Option::is_none<Account::WithdrawCapability>($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:9+68

    // assume WellFormed($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:9+68
    assume $IsValid'bool'($t4);

    // assume Eq<bool>($t4, Option::$is_none<Account::WithdrawCapability>($t3)) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:9+68
    assume $IsEqual'bool'($t4, $1_Option_$is_none'$1_Account_WithdrawCapability'($t3));

    // $t4 := opaque end: Option::is_none<Account::WithdrawCapability>($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:9+68

    // trace_return[0]($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:802:9+68
    assume {:print "$track_return(29,13,0):", $t4} $t4 == $t4;

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:803:5+1
    assume {:print "$at(80,33110,33111)"} true;
L1:

    // return $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:803:5+1
    $ret0 := $t4;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:803:5+1
L2:

    // abort($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:803:5+1
    $abort_code := $t2;
    $abort_flag := true;
    return;

}

// fun Account::deposit_to_balance<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:353:5+164
procedure {:inline 1} $1_Account_deposit_to_balance'#0'(_$t0: $Mutation ($1_Account_Balance'#0'), _$t1: $1_Token_Token'#0') returns ($ret0: $Mutation ($1_Account_Balance'#0'))
{
    // declare local variables
    var $t2: $Mutation ($1_Token_Token'#0');
    var $t3: int;
    var $t0: $Mutation ($1_Account_Balance'#0');
    var $t1: $1_Token_Token'#0';
    var $temp_0'$1_Account_Balance'#0'': $1_Account_Balance'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    $t0 := _$t0;
    $t1 := _$t1;
    assume IsEmptyVec(p#$Mutation($t2));

    // bytecode translation starts here
    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:353:5+1
    assume {:print "$at(80,14509,14510)"} true;
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,15,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // trace_local[token]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:353:5+1
    assume {:print "$track_local(29,15,1):", $t1} $t1 == $t1;

    // $t2 := borrow_field<Account::Balance<#0>>.token($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:354:24+18
    assume {:print "$at(80,14641,14659)"} true;
    $t2 := $ChildMutation($t0, 0, $token#$1_Account_Balance'#0'($Dereference($t0)));

    // Token::deposit<#0>($t2, $t1) on_abort goto L2 with $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:354:9+41
    call $t2 := $1_Token_deposit'#0'($t2, $t1);
    if ($abort_flag) {
        assume {:print "$at(80,14626,14667)"} true;
        $t3 := $abort_code;
        assume {:print "$track_abort(29,15):", $t3} $t3 == $t3;
        goto L2;
    }

    // write_back[Reference($t0).token (Token::Token<#0>)]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:354:9+41
    $t0 := $UpdateMutation($t0, $Update'$1_Account_Balance'#0''_token($Dereference($t0), $Dereference($t2)));

    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:354:9+41
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,15,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:354:9+41
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,15,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:355:5+1
    assume {:print "$at(80,14672,14673)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:355:5+1
    $ret0 := $t0;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:355:5+1
L2:

    // abort($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:355:5+1
    $abort_code := $t3;
    $abort_flag := true;
    return;

}

// fun Account::deposit_with_metadata<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:315:5+687
procedure {:inline 1} $1_Account_deposit_with_metadata'#0'(_$t0: int, _$t1: $1_Token_Token'#0', _$t2: Vec (int)) returns ()
{
    // declare local variables
    var $t3: int;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: bool;
    var $t8: $Mutation ($1_Account_Balance'#0');
    var $t0: int;
    var $t1: $1_Token_Token'#0';
    var $t2: Vec (int);
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'address': int;
    var $temp_0'u128': int;
    var $temp_0'vec'u8'': Vec (int);
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;
    assume IsEmptyVec(p#$Mutation($t8));

    // bytecode translation starts here
    // trace_local[receiver]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:315:5+1
    assume {:print "$at(80,13084,13085)"} true;
    assume {:print "$track_local(29,17,0):", $t0} $t0 == $t0;

    // trace_local[to_deposit]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:315:5+1
    assume {:print "$track_local(29,17,1):", $t1} $t1 == $t1;

    // trace_local[metadata]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:315:5+1
    assume {:print "$track_local(29,17,2):", $t2} $t2 == $t2;

    // Account::try_accept_token<#0>($t0) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:320:9+37
    assume {:print "$at(80,13290,13327)"} true;
    call $1_Account_try_accept_token'#0'($t0);
    if ($abort_flag) {
        assume {:print "$at(80,13290,13327)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // $t5 := Token::value<#0>($t1) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:322:29+25
    assume {:print "$at(80,13358,13383)"} true;
    call $t5 := $1_Token_value'#0'($t1);
    if ($abort_flag) {
        assume {:print "$at(80,13358,13383)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // trace_local[deposit_value]($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:322:13+13
    assume {:print "$track_local(29,17,3):", $t5} $t5 == $t5;

    // $t6 := 0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:323:29+5
    assume {:print "$at(80,13413,13418)"} true;
    $t6 := 0;
    assume $IsValid'u128'($t6);

    // $t7 := >($t5, $t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:323:27+1
    call $t7 := $Gt($t5, $t6);

    // if ($t7) goto L0 else goto L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:323:9+371
    if ($t7) { goto L0; } else { goto L2; }

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:325:81+8
    assume {:print "$at(80,13548,13556)"} true;
L0:

    // $t8 := borrow_global<Account::Balance<#0>>($t0) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:325:43+17
    if (!$ResourceExists($1_Account_Balance'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t8 := $Mutation($Global($t0), EmptyVec(), $ResourceValue($1_Account_Balance'#0'_$memory, $t0));
    }
    if ($abort_flag) {
        assume {:print "$at(80,13510,13527)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // Account::deposit_to_balance<#0>($t8, $t1) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:325:13+90
    call $t8 := $1_Account_deposit_to_balance'#0'($t8, $t1);
    if ($abort_flag) {
        assume {:print "$at(80,13480,13570)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // write_back[Account::Balance<#0>@]($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:325:13+90
    $1_Account_Balance'#0'_$memory := $ResourceUpdate($1_Account_Balance'#0'_$memory, $GlobalLocationAddress($t8),
        $Dereference($t8));

    // Account::emit_account_deposit_event<#0>($t0, $t5, $t2) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:328:13+72
    assume {:print "$at(80,13619,13691)"} true;
    call $1_Account_emit_account_deposit_event'#0'($t0, $t5, $t2);
    if ($abort_flag) {
        assume {:print "$at(80,13619,13691)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // goto L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:328:85+1
    goto L3;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:330:33+10
    assume {:print "$at(80,13742,13752)"} true;
L2:

    // Token::destroy_zero<#0>($t1) on_abort goto L5 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:330:13+31
    call $1_Token_destroy_zero'#0'($t1);
    if ($abort_flag) {
        assume {:print "$at(80,13722,13753)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,17):", $t4} $t4 == $t4;
        goto L5;
    }

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:331:10+1
    assume {:print "$at(80,13764,13765)"} true;
L3:

    // label L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:332:5+1
    assume {:print "$at(80,13770,13771)"} true;
L4:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:332:5+1
    return;

    // label L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:332:5+1
L5:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:332:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::do_accept_token<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:675:5+580
procedure {:inline 1} $1_Account_do_accept_token'#0'(_$t0: $signer) returns ()
{
    // declare local variables
    var $t1: $Mutation ($1_Account_Account);
    var $t2: $1_Token_TokenCode;
    var $t3: $1_Token_Token'#0';
    var $t4: int;
    var $t5: $1_Account_Balance'#0';
    var $t6: $1_Token_TokenCode;
    var $t7: int;
    var $t8: $Mutation ($1_Account_Account);
    var $t9: $Mutation ($1_Event_EventHandle'$1_Account_AcceptTokenEvent');
    var $t10: $1_Account_AcceptTokenEvent;
    var $t0: $signer;
    var $temp_0'$1_Account_Account': $1_Account_Account;
    var $temp_0'$1_Token_TokenCode': $1_Token_TokenCode;
    var $temp_0'signer': $signer;
    $t0 := _$t0;
    assume IsEmptyVec(p#$Mutation($t1));
    assume IsEmptyVec(p#$Mutation($t8));
    assume IsEmptyVec(p#$Mutation($t9));

    // bytecode translation starts here
    // trace_local[account]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:675:5+1
    assume {:print "$at(80,28835,28836)"} true;
    assume {:print "$track_local(29,20,0):", $t0} $t0 == $t0;

    // $t3 := Token::zero<#0>() on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:676:53+24
    assume {:print "$at(80,28969,28993)"} true;
    call $t3 := $1_Token_zero'#0'();
    if ($abort_flag) {
        assume {:print "$at(80,28969,28993)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,20):", $t4} $t4 == $t4;
        goto L2;
    }

    // $t5 := pack Account::Balance<#0>($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:676:26+53
    $t5 := $1_Account_Balance'#0'($t3);

    // move_to<Account::Balance<#0>>($t5, $t0) on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:676:9+7
    if ($ResourceExists($1_Account_Balance'#0'_$memory, $addr#$signer($t0))) {
        call $ExecFailureAbort();
    } else {
        $1_Account_Balance'#0'_$memory := $ResourceUpdate($1_Account_Balance'#0'_$memory, $addr#$signer($t0), $t5);
    }
    if ($abort_flag) {
        assume {:print "$at(80,28925,28932)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,20):", $t4} $t4 == $t4;
        goto L2;
    }

    // $t6 := opaque begin: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:677:26+30
    assume {:print "$at(80,29023,29053)"} true;

    // assume WellFormed($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:677:26+30
    assume $IsValid'$1_Token_TokenCode'($t6);

    // $t6 := opaque end: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:677:26+30

    // trace_local[token_code]($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:677:13+10
    assume {:print "$track_local(29,20,2):", $t6} $t6 == $t6;

    // $t7 := opaque begin: Signer::address_of($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:61+27
    assume {:print "$at(80,29152,29179)"} true;

    // assume WellFormed($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:61+27
    assume $IsValid'address'($t7);

    // assume Eq<address>($t7, Signer::$address_of($t0)) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:61+27
    assume $IsEqual'address'($t7, $1_Signer_$address_of($t0));

    // $t7 := opaque end: Signer::address_of($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:61+27

    // $t8 := borrow_global<Account::Account>($t7) on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:34+17
    if (!$ResourceExists($1_Account_Account_$memory, $t7)) {
        call $ExecFailureAbort();
    } else {
        $t8 := $Mutation($Global($t7), EmptyVec(), $ResourceValue($1_Account_Account_$memory, $t7));
    }
    if ($abort_flag) {
        assume {:print "$at(80,29125,29142)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,20):", $t4} $t4 == $t4;
        goto L2;
    }

    // trace_local[sender_account_ref]($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:679:13+18
    $temp_0'$1_Account_Account' := $Dereference($t8);
    assume {:print "$track_local(29,20,1):", $temp_0'$1_Account_Account'} $temp_0'$1_Account_Account' == $temp_0'$1_Account_Account';

    // $t9 := borrow_field<Account::Account>.accept_token_events($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:682:13+43
    assume {:print "$at(80,29267,29310)"} true;
    $t9 := $ChildMutation($t8, 5, $accept_token_events#$1_Account_Account($Dereference($t8)));

    // $t10 := pack Account::AcceptTokenEvent($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:683:13+73
    assume {:print "$at(80,29324,29397)"} true;
    $t10 := $1_Account_AcceptTokenEvent($t6);

    // Event::emit_event<Account::AcceptTokenEvent>($t9, $t10) on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:681:9+190
    assume {:print "$at(80,29218,29408)"} true;
    call $t9 := $1_Event_emit_event'$1_Account_AcceptTokenEvent'($t9, $t10);
    if ($abort_flag) {
        assume {:print "$at(80,29218,29408)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,20):", $t4} $t4 == $t4;
        goto L2;
    }

    // pack_ref_deep($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:681:9+190

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:687:5+1
    assume {:print "$at(80,29414,29415)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:687:5+1
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:687:5+1
L2:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:687:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::emit_account_deposit_event<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:483:5+416
procedure {:inline 1} $1_Account_emit_account_deposit_event'#0'(_$t0: int, _$t1: int, _$t2: Vec (int)) returns ()
{
    // declare local variables
    var $t3: $Mutation ($1_Account_Account);
    var $t4: $Mutation ($1_Account_Account);
    var $t5: int;
    var $t6: $Mutation ($1_Event_EventHandle'$1_Account_DepositEvent');
    var $t7: $1_Token_TokenCode;
    var $t8: $1_Account_DepositEvent;
    var $t0: int;
    var $t1: int;
    var $t2: Vec (int);
    var $temp_0'$1_Account_Account': $1_Account_Account;
    var $temp_0'address': int;
    var $temp_0'u128': int;
    var $temp_0'vec'u8'': Vec (int);
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;
    assume IsEmptyVec(p#$Mutation($t3));
    assume IsEmptyVec(p#$Mutation($t4));
    assume IsEmptyVec(p#$Mutation($t6));

    // bytecode translation starts here
    // trace_local[account]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:483:5+1
    assume {:print "$at(80,20459,20460)"} true;
    assume {:print "$track_local(29,21,0):", $t0} $t0 == $t0;

    // trace_local[amount]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:483:5+1
    assume {:print "$track_local(29,21,1):", $t1} $t1 == $t1;

    // trace_local[metadata]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:483:5+1
    assume {:print "$track_local(29,21,2):", $t2} $t2 == $t2;

    // $t4 := borrow_global<Account::Account>($t0) on_abort goto L2 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:486:23+17
    assume {:print "$at(80,20638,20655)"} true;
    if (!$ResourceExists($1_Account_Account_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t4 := $Mutation($Global($t0), EmptyVec(), $ResourceValue($1_Account_Account_$memory, $t0));
    }
    if ($abort_flag) {
        assume {:print "$at(80,20638,20655)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,21):", $t5} $t5 == $t5;
        goto L2;
    }

    // trace_local[account#1]($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:486:13+7
    $temp_0'$1_Account_Account' := $Dereference($t4);
    assume {:print "$track_local(29,21,3):", $temp_0'$1_Account_Account'} $temp_0'$1_Account_Account' == $temp_0'$1_Account_Account';

    // $t6 := borrow_field<Account::Account>.deposit_events($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:488:41+27
    assume {:print "$at(80,20716,20743)"} true;
    $t6 := $ChildMutation($t4, 4, $deposit_events#$1_Account_Account($Dereference($t4)));

    // $t7 := opaque begin: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:490:25+30
    assume {:print "$at(80,20804,20834)"} true;

    // assume WellFormed($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:490:25+30
    assume $IsValid'$1_Token_TokenCode'($t7);

    // $t7 := opaque end: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:490:25+30

    // $t8 := pack Account::DepositEvent($t1, $t7, $t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:488:70+122
    assume {:print "$at(80,20745,20867)"} true;
    $t8 := $1_Account_DepositEvent($t1, $t7, $t2);

    // Event::emit_event<Account::DepositEvent>($t6, $t8) on_abort goto L2 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:488:9+184
    call $t6 := $1_Event_emit_event'$1_Account_DepositEvent'($t6, $t8);
    if ($abort_flag) {
        assume {:print "$at(80,20684,20868)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,21):", $t5} $t5 == $t5;
        goto L2;
    }

    // pack_ref_deep($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:488:9+184

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:493:5+1
    assume {:print "$at(80,20874,20875)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:493:5+1
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:493:5+1
L2:

    // abort($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:493:5+1
    $abort_code := $t5;
    $abort_flag := true;
    return;

}

// fun Account::emit_account_withdraw_event<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:468:5+420
procedure {:inline 1} $1_Account_emit_account_withdraw_event'#0'(_$t0: int, _$t1: int, _$t2: Vec (int)) returns ()
{
    // declare local variables
    var $t3: $Mutation ($1_Account_Account);
    var $t4: $Mutation ($1_Account_Account);
    var $t5: int;
    var $t6: $Mutation ($1_Event_EventHandle'$1_Account_WithdrawEvent');
    var $t7: $1_Token_TokenCode;
    var $t8: $1_Account_WithdrawEvent;
    var $t0: int;
    var $t1: int;
    var $t2: Vec (int);
    var $temp_0'$1_Account_Account': $1_Account_Account;
    var $temp_0'address': int;
    var $temp_0'u128': int;
    var $temp_0'vec'u8'': Vec (int);
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;
    assume IsEmptyVec(p#$Mutation($t3));
    assume IsEmptyVec(p#$Mutation($t4));
    assume IsEmptyVec(p#$Mutation($t6));

    // bytecode translation starts here
    // trace_local[account]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:468:5+1
    assume {:print "$at(80,19943,19944)"} true;
    assume {:print "$track_local(29,22,0):", $t0} $t0 == $t0;

    // trace_local[amount]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:468:5+1
    assume {:print "$track_local(29,22,1):", $t1} $t1 == $t1;

    // trace_local[metadata]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:468:5+1
    assume {:print "$track_local(29,22,2):", $t2} $t2 == $t2;

    // $t4 := borrow_global<Account::Account>($t0) on_abort goto L2 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:471:23+17
    assume {:print "$at(80,20123,20140)"} true;
    if (!$ResourceExists($1_Account_Account_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t4 := $Mutation($Global($t0), EmptyVec(), $ResourceValue($1_Account_Account_$memory, $t0));
    }
    if ($abort_flag) {
        assume {:print "$at(80,20123,20140)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,22):", $t5} $t5 == $t5;
        goto L2;
    }

    // trace_local[account#1]($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:471:13+7
    $temp_0'$1_Account_Account' := $Dereference($t4);
    assume {:print "$track_local(29,22,3):", $temp_0'$1_Account_Account'} $temp_0'$1_Account_Account' == $temp_0'$1_Account_Account';

    // $t6 := borrow_field<Account::Account>.withdraw_events($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:473:42+28
    assume {:print "$at(80,20202,20230)"} true;
    $t6 := $ChildMutation($t4, 3, $withdraw_events#$1_Account_Account($Dereference($t4)));

    // $t7 := opaque begin: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:475:25+30
    assume {:print "$at(80,20292,20322)"} true;

    // assume WellFormed($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:475:25+30
    assume $IsValid'$1_Token_TokenCode'($t7);

    // $t7 := opaque end: Token::token_code<#0>() at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:475:25+30

    // $t8 := pack Account::WithdrawEvent($t1, $t7, $t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:473:72+123
    assume {:print "$at(80,20232,20355)"} true;
    $t8 := $1_Account_WithdrawEvent($t1, $t7, $t2);

    // Event::emit_event<Account::WithdrawEvent>($t6, $t8) on_abort goto L2 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:473:9+187
    call $t6 := $1_Event_emit_event'$1_Account_WithdrawEvent'($t6, $t8);
    if ($abort_flag) {
        assume {:print "$at(80,20169,20356)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,22):", $t5} $t5 == $t5;
        goto L2;
    }

    // pack_ref_deep($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:473:9+187

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:478:5+1
    assume {:print "$at(80,20362,20363)"} true;
L1:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:478:5+1
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:478:5+1
L2:

    // abort($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:478:5+1
    $abort_code := $t5;
    $abort_flag := true;
    return;

}

// fun Account::try_accept_token<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:748:5+404
procedure {:inline 1} $1_Account_try_accept_token'#0'(_$t0: int) returns ()
{
    // declare local variables
    var $t1: $signer;
    var $t2: bool;
    var $t3: bool;
    var $t4: bool;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: $signer;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'signer': $signer;
    $t0 := _$t0;

    // bytecode translation starts here
    // trace_local[addr]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:748:5+1
    assume {:print "$at(80,31249,31250)"} true;
    assume {:print "$track_local(29,45,0):", $t0} $t0 == $t0;

    // $t2 := exists<Account::Balance<#0>>($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:749:14+6
    assume {:print "$at(80,31352,31358)"} true;
    $t2 := $ResourceExists($1_Account_Balance'#0'_$memory, $t0);

    // $t3 := !($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:749:13+1
    call $t3 := $Not($t2);

    // if ($t3) goto L0 else goto L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:749:9+299
    if ($t3) { goto L0; } else { goto L2; }

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:750:39+4
    assume {:print "$at(80,31426,31430)"} true;
L0:

    // $t4 := Account::can_auto_accept_token($t0) on_abort goto L6 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:750:17+27
    call $t4 := $1_Account_can_auto_accept_token($t0);
    if ($abort_flag) {
        assume {:print "$at(80,31404,31431)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,45):", $t5} $t5 == $t5;
        goto L6;
    }

    // if ($t4) goto L3 else goto L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:750:13+236
    if ($t4) { goto L3; } else { goto L4; }

    // label L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:45+20
    assume {:print "$at(80,31601,31621)"} true;
L4:

    // $t6 := 106 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:45+20
    $t6 := 106;
    assume $IsValid'u64'($t6);

    // $t7 := opaque begin: Errors::not_published($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:23+43

    // assume WellFormed($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:23+43
    assume $IsValid'u64'($t7);

    // assume Eq<u64>($t7, 5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:23+43
    assume $IsEqual'u64'($t7, 5);

    // $t7 := opaque end: Errors::not_published($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:23+43

    // trace_abort($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:17+49
    assume {:print "$at(80,31573,31622)"} true;
    assume {:print "$track_abort(29,45):", $t7} $t7 == $t7;

    // $t5 := move($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:17+49
    $t5 := $t7;

    // goto L6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:754:17+49
    goto L6;

    // label L3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:751:44+4
    assume {:print "$at(80,31478,31482)"} true;
L3:

    // $t8 := Account::create_signer($t0) on_abort goto L6 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:751:30+19
    call $t8 := $1_Account_create_signer($t0);
    if ($abort_flag) {
        assume {:print "$at(80,31464,31483)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,45):", $t5} $t5 == $t5;
        goto L6;
    }

    // trace_local[signer]($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:751:21+6
    assume {:print "$track_local(29,45,1):", $t8} $t8 == $t8;

    // Account::do_accept_token<#0>($t8) on_abort goto L6 with $t5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:752:17+35
    assume {:print "$at(80,31501,31536)"} true;
    call $1_Account_do_accept_token'#0'($t8);
    if ($abort_flag) {
        assume {:print "$at(80,31501,31536)"} true;
        $t5 := $abort_code;
        assume {:print "$track_abort(29,45):", $t5} $t5 == $t5;
        goto L6;
    }

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:756:10+1
    assume {:print "$at(80,31646,31647)"} true;
L2:

    // label L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:757:5+1
    assume {:print "$at(80,31652,31653)"} true;
L5:

    // return () at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:757:5+1
    return;

    // label L6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:757:5+1
L6:

    // abort($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:757:5+1
    $abort_code := $t5;
    $abort_flag := true;
    return;

}

// fun Account::withdraw_from_balance<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:364:5+168
procedure {:inline 1} $1_Account_withdraw_from_balance'#0'(_$t0: $Mutation ($1_Account_Balance'#0'), _$t1: int) returns ($ret0: $1_Token_Token'#0', $ret1: $Mutation ($1_Account_Balance'#0'))
{
    // declare local variables
    var $t2: $Mutation ($1_Token_Token'#0');
    var $t3: $1_Token_Token'#0';
    var $t4: int;
    var $t0: $Mutation ($1_Account_Balance'#0');
    var $t1: int;
    var $temp_0'$1_Account_Balance'#0'': $1_Account_Balance'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'u128': int;
    $t0 := _$t0;
    $t1 := _$t1;
    assume IsEmptyVec(p#$Mutation($t2));

    // bytecode translation starts here
    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:364:5+1
    assume {:print "$at(80,14891,14892)"} true;
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,51,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // trace_local[amount]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:364:5+1
    assume {:print "$track_local(29,51,1):", $t1} $t1 == $t1;

    // $t2 := borrow_field<Account::Balance<#0>>.token($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:25+18
    assume {:print "$at(80,15026,15044)"} true;
    $t2 := $ChildMutation($t0, 0, $token#$1_Account_Balance'#0'($Dereference($t0)));

    // $t3 := Token::withdraw<#0>($t2, $t1) on_abort goto L2 with $t4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:9+43
    call $t3,$t2 := $1_Token_withdraw'#0'($t2, $t1);
    if ($abort_flag) {
        assume {:print "$at(80,15010,15053)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(29,51):", $t4} $t4 == $t4;
        goto L2;
    }

    // write_back[Reference($t0).token (Token::Token<#0>)]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:9+43
    $t0 := $UpdateMutation($t0, $Update'$1_Account_Balance'#0''_token($Dereference($t0), $Dereference($t2)));

    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:9+43
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,51,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // trace_return[0]($t3) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:9+43
    assume {:print "$track_return(29,51,0):", $t3} $t3 == $t3;

    // trace_local[balance]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:365:9+43
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t0);
    assume {:print "$track_local(29,51,0):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:366:5+1
    assume {:print "$at(80,15058,15059)"} true;
L1:

    // return $t3 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:366:5+1
    $ret0 := $t3;
    $ret1 := $t0;
    return;

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:366:5+1
L2:

    // abort($t4) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:366:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Account::withdraw_with_metadata<#0> [baseline] at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:386:5+816
procedure {:inline 1} $1_Account_withdraw_with_metadata'#0'(_$t0: $signer, _$t1: int, _$t2: Vec (int)) returns ($ret0: $1_Token_Token'#0')
{
    // declare local variables
    var $t3: int;
    var $t4: $Mutation ($1_Account_Balance'#0');
    var $t5: int;
    var $t6: $Mutation ($1_Account_Balance'#0');
    var $t7: int;
    var $t8: bool;
    var $t9: bool;
    var $t10: int;
    var $t11: int;
    var $t12: int;
    var $t13: bool;
    var $t14: $1_Token_Token'#0';
    var $t15: $1_Token_Token'#0';
    var $t16: $1_Token_Token'#0';
    var $t0: $signer;
    var $t1: int;
    var $t2: Vec (int);
    var $temp_0'$1_Account_Balance'#0'': $1_Account_Balance'#0';
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'address': int;
    var $temp_0'signer': $signer;
    var $temp_0'u128': int;
    var $temp_0'vec'u8'': Vec (int);
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;
    assume IsEmptyVec(p#$Mutation($t4));
    assume IsEmptyVec(p#$Mutation($t6));

    // bytecode translation starts here
    // trace_local[account]($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:386:5+1
    assume {:print "$at(80,15853,15854)"} true;
    assume {:print "$track_local(29,54,0):", $t0} $t0 == $t0;

    // trace_local[amount]($t1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:386:5+1
    assume {:print "$track_local(29,54,1):", $t1} $t1 == $t1;

    // trace_local[metadata]($t2) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:386:5+1
    assume {:print "$track_local(29,54,2):", $t2} $t2 == $t2;

    // $t5 := opaque begin: Signer::address_of($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:388:27+27
    assume {:print "$at(80,16035,16062)"} true;

    // assume WellFormed($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:388:27+27
    assume $IsValid'address'($t5);

    // assume Eq<address>($t5, Signer::$address_of($t0)) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:388:27+27
    assume $IsEqual'address'($t5, $1_Signer_$address_of($t0));

    // $t5 := opaque end: Signer::address_of($t0) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:388:27+27

    // trace_local[sender_addr]($t5) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:388:13+11
    assume {:print "$track_local(29,54,3):", $t5} $t5 == $t5;

    // $t6 := borrow_global<Account::Balance<#0>>($t5) on_abort goto L6 with $t7 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:389:30+17
    assume {:print "$at(80,16093,16110)"} true;
    if (!$ResourceExists($1_Account_Balance'#0'_$memory, $t5)) {
        call $ExecFailureAbort();
    } else {
        $t6 := $Mutation($Global($t5), EmptyVec(), $ResourceValue($1_Account_Balance'#0'_$memory, $t5));
    }
    if ($abort_flag) {
        assume {:print "$at(80,16093,16110)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(29,54):", $t7} $t7 == $t7;
        goto L6;
    }

    // trace_local[sender_balance]($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:389:13+14
    $temp_0'$1_Account_Balance'#0'' := $Dereference($t6);
    assume {:print "$track_local(29,54,4):", $temp_0'$1_Account_Balance'#0''} $temp_0'$1_Account_Balance'#0'' == $temp_0'$1_Account_Balance'#0'';

    // $t8 := Account::delegated_withdraw_capability($t5) on_abort goto L6 with $t7 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:18+42
    assume {:print "$at(80,16264,16306)"} true;
    call $t8 := $1_Account_delegated_withdraw_capability($t5);
    if ($abort_flag) {
        assume {:print "$at(80,16264,16306)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(29,54):", $t7} $t7 == $t7;
        goto L6;
    }

    // $t9 := !($t8) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:17+1
    call $t9 := $Not($t8);

    // if ($t9) goto L0 else goto L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117
    if ($t9) { goto L0; } else { goto L1; }

    // label L1 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117
L1:

    // destroy($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117

    // $t10 := 101 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:84+40
    $t10 := 101;
    assume $IsValid'u64'($t10);

    // $t11 := opaque begin: Errors::invalid_state($t10) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:62+63

    // assume WellFormed($t11) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:62+63
    assume $IsValid'u64'($t11);

    // assume Eq<u64>($t11, 1) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:62+63
    assume $IsEqual'u64'($t11, 1);

    // $t11 := opaque end: Errors::invalid_state($t10) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:62+63

    // trace_abort($t11) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117
    assume {:print "$at(80,16255,16372)"} true;
    assume {:print "$track_abort(29,54):", $t11} $t11 == $t11;

    // $t7 := move($t11) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117
    $t7 := $t11;

    // goto L6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:391:9+117
    goto L6;

    // label L0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:392:13+6
    assume {:print "$at(80,16386,16392)"} true;
L0:

    // $t12 := 0 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:392:23+1
    $t12 := 0;
    assume $IsValid'u128'($t12);

    // $t13 := ==($t1, $t12) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:392:20+2
    $t13 := $IsEqual'u128'($t1, $t12);

    // if ($t13) goto L2 else goto L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:392:9+60
    if ($t13) { goto L2; } else { goto L4; }

    // label L2 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:13+20
    assume {:print "$at(80,16412,16432)"} true;
L2:

    // destroy($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:13+20

    // $t14 := Token::zero<#0>() on_abort goto L6 with $t7 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:20+13
    call $t14 := $1_Token_zero'#0'();
    if ($abort_flag) {
        assume {:print "$at(80,16419,16432)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(29,54):", $t7} $t7 == $t7;
        goto L6;
    }

    // trace_return[0]($t14) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:13+20
    assume {:print "$track_return(29,54,0):", $t14} $t14 == $t14;

    // $t15 := move($t14) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:13+20
    $t15 := $t14;

    // goto L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:393:13+20
    goto L5;

    // label L4 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:395:48+11
    assume {:print "$at(80,16491,16502)"} true;
L4:

    // Account::emit_account_withdraw_event<#0>($t5, $t1, $t2) on_abort goto L6 with $t7 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:395:9+69
    call $1_Account_emit_account_withdraw_event'#0'($t5, $t1, $t2);
    if ($abort_flag) {
        assume {:print "$at(80,16452,16521)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(29,54):", $t7} $t7 == $t7;
        goto L6;
    }

    // $t16 := Account::withdraw_from_balance<#0>($t6, $t1) on_abort goto L6 with $t7 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:397:9+56
    assume {:print "$at(80,16607,16663)"} true;
    call $t16,$t6 := $1_Account_withdraw_from_balance'#0'($t6, $t1);
    if ($abort_flag) {
        assume {:print "$at(80,16607,16663)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(29,54):", $t7} $t7 == $t7;
        goto L6;
    }

    // write_back[Account::Balance<#0>@]($t6) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:397:9+56
    $1_Account_Balance'#0'_$memory := $ResourceUpdate($1_Account_Balance'#0'_$memory, $GlobalLocationAddress($t6),
        $Dereference($t6));

    // trace_return[0]($t16) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:397:9+56
    assume {:print "$track_return(29,54,0):", $t16} $t16 == $t16;

    // $t15 := move($t16) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:397:9+56
    $t15 := $t16;

    // label L5 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:398:5+1
    assume {:print "$at(80,16668,16669)"} true;
L5:

    // return $t15 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:398:5+1
    $ret0 := $t15;
    return;

    // label L6 at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:398:5+1
L6:

    // abort($t7) at /home/joker/.move/https___github_com_starcoinorg_starcoin-framework_git_cf1deda180af40a8b3e26c0c7b548c4c290cd7e7/sources/Account.move:398:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

}

// struct Vesting::Credentials<#0> at ./sources/Vesting.move:16:5+206
type {:datatype} $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
function {:constructor} $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token: $1_Token_Token'#0', $start: int, $duration: int, $id: int, $released: int, $total: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_token(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: $1_Token_Token'#0'): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(x, $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_start(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), x, $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_duration(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), x, $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_id(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), x, $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_released(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), x, $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_total(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', x: int): $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0' {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s), x)
}
function $IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'): bool {
    $IsValid'$1_Token_Token'#0''($token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
      && $IsValid'u64'($start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
      && $IsValid'u64'($duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
      && $IsValid'u64'($id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
      && $IsValid'u128'($released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
      && $IsValid'u128'($total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'(s))
}
function {:inline} $IsEqual'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''(s1: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0', s2: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'): bool {
    s1 == s2
}
var $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory: $Memory $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';

// struct Vesting::MyCounter at ./sources/Vesting.move:15:5+28
type {:datatype} $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
function {:constructor} $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter($dummy_field: bool): $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
function {:inline} $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_dummy_field(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter, x: bool): $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter {
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter(x)
}
function $IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(s: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter): bool {
    $IsValid'bool'($dummy_field#$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter(s))
}
function {:inline} $IsEqual'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'(s1: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter, s2: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter): bool {
    s1 == s2
}

// fun Vesting::duration_seconds [verification] at ./sources/Vesting.move:79:5+261
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_duration_seconds$verify(_$t0: int) returns ($ret0: int)
{
    // declare local variables
    var $t1: bool;
    var $t2: int;
    var $t3: int;
    var $t4: int;
    var $t5: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $t6: int;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'u64': int;
    $t0 := _$t0;

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:79:5+1
    assume {:print "$at(22,3426,3427)"} true;
    assume $IsValid'address'($t0);

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:79:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[addr]($t0) at ./sources/Vesting.move:79:5+1
    assume {:print "$track_local(30,2,0):", $t0} $t0 == $t0;

    // $t1 := exists<Vesting::Credentials<#0>>($t0) at ./sources/Vesting.move:80:17+6
    assume {:print "$at(22,3531,3537)"} true;
    $t1 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);

    // if ($t1) goto L0 else goto L1 at ./sources/Vesting.move:80:9+96
    if ($t1) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:80:77+26
L1:

    // $t2 := 3 at ./sources/Vesting.move:80:77+26
    $t2 := 3;
    assume $IsValid'u64'($t2);

    // $t3 := opaque begin: Errors::not_published($t2) at ./sources/Vesting.move:80:55+49

    // assume WellFormed($t3) at ./sources/Vesting.move:80:55+49
    assume $IsValid'u64'($t3);

    // assume Eq<u64>($t3, 5) at ./sources/Vesting.move:80:55+49
    assume $IsEqual'u64'($t3, 5);

    // $t3 := opaque end: Errors::not_published($t2) at ./sources/Vesting.move:80:55+49

    // trace_abort($t3) at ./sources/Vesting.move:80:9+96
    assume {:print "$at(22,3523,3619)"} true;
    assume {:print "$track_abort(30,2):", $t3} $t3 == $t3;

    // $t4 := move($t3) at ./sources/Vesting.move:80:9+96
    $t4 := $t3;

    // goto L3 at ./sources/Vesting.move:80:9+96
    goto L3;

    // label L0 at ./sources/Vesting.move:81:47+4
    assume {:print "$at(22,3667,3671)"} true;
L0:

    // $t5 := get_global<Vesting::Credentials<#0>>($t0) on_abort goto L3 with $t4 at ./sources/Vesting.move:81:9+13
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t5 := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(22,3629,3642)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(30,2):", $t4} $t4 == $t4;
        goto L3;
    }

    // $t6 := get_field<Vesting::Credentials<#0>>.duration($t5) at ./sources/Vesting.move:81:9+52
    $t6 := $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($t5);

    // trace_return[0]($t6) at ./sources/Vesting.move:81:9+52
    assume {:print "$track_return(30,2,0):", $t6} $t6 == $t6;

    // label L2 at ./sources/Vesting.move:82:5+1
    assume {:print "$at(22,3686,3687)"} true;
L2:

    // return $t6 at ./sources/Vesting.move:82:5+1
    $ret0 := $t6;
    return;

    // label L3 at ./sources/Vesting.move:82:5+1
L3:

    // abort($t4) at ./sources/Vesting.move:82:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Vesting::add_vesting [verification] at ./sources/Vesting.move:41:5+1067
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_add_vesting$verify(_$t0: $signer, _$t1: int, _$t2: int, _$t3: int, _$t4: int) returns ()
{
    // declare local variables
    var $t5: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
    var $t6: $signer;
    var $t7: $Mutation ($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0');
    var $t8: $1_Token_Token'#0';
    var $t9: bool;
    var $t10: int;
    var $t11: int;
    var $t12: int;
    var $t13: int;
    var $t14: bool;
    var $t15: int;
    var $t16: int;
    var $t17: int;
    var $t18: int;
    var $t19: bool;
    var $t20: int;
    var $t21: int;
    var $t22: int;
    var $t23: bool;
    var $t24: bool;
    var $t25: $Mutation ($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0');
    var $t26: $1_Token_Token'#0';
    var $t27: $Mutation ($1_Token_Token'#0');
    var $t28: $Mutation (int);
    var $t29: $Mutation (int);
    var $t30: bool;
    var $t31: $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
    var $t32: int;
    var $t33: $Mutation (int);
    var $t34: $Mutation (int);
    var $t0: $signer;
    var $t1: int;
    var $t2: int;
    var $t3: int;
    var $t4: int;
    var $temp_0'$1_Token_Token'#0'': $1_Token_Token'#0';
    var $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'': $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter': $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter;
    var $temp_0'address': int;
    var $temp_0'signer': $signer;
    var $temp_0'u128': int;
    var $temp_0'u64': int;
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;
    $t3 := _$t3;
    $t4 := _$t4;
    assume IsEmptyVec(p#$Mutation($t7));
    assume IsEmptyVec(p#$Mutation($t25));
    assume IsEmptyVec(p#$Mutation($t27));
    assume IsEmptyVec(p#$Mutation($t28));
    assume IsEmptyVec(p#$Mutation($t29));
    assume IsEmptyVec(p#$Mutation($t33));
    assume IsEmptyVec(p#$Mutation($t34));

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:41:5+1
    assume {:print "$at(22,1342,1343)"} true;
    assume $IsValid'signer'($t0) && $1_Signer_is_txn_signer($t0) && $1_Signer_is_txn_signer_addr($addr#$signer($t0));

    // assume WellFormed($t1) at ./sources/Vesting.move:41:5+1
    assume $IsValid'u128'($t1);

    // assume WellFormed($t2) at ./sources/Vesting.move:41:5+1
    assume $IsValid'address'($t2);

    // assume WellFormed($t3) at ./sources/Vesting.move:41:5+1
    assume $IsValid'u64'($t3);

    // assume WellFormed($t4) at ./sources/Vesting.move:41:5+1
    assume $IsValid'u64'($t4);

    // assume forall $rsc: ResourceDomain<Counter::Counter<Counter::Counter<Vesting::MyCounter>>>(): WellFormed($rsc) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'''($rsc))));

    // assume forall $rsc: ResourceDomain<Counter::Counter<Vesting::MyCounter>>(): WellFormed($rsc) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''($rsc))));

    // assume forall $rsc: ResourceDomain<Timestamp::CurrentTimeMilliseconds>(): WellFormed($rsc) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0)}(var $rsc := $ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0);
    ($IsValid'$1_Timestamp_CurrentTimeMilliseconds'($rsc))));

    // assume forall $rsc: ResourceDomain<Account::Account>(): And(WellFormed($rsc), And(Le(Len<Account::WithdrawCapability>(select Option::Option.vec(select Account::Account.withdrawal_capability($rsc))), 1), Le(Len<Account::KeyRotationCapability>(select Option::Option.vec(select Account::Account.key_rotation_capability($rsc))), 1))) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Account_Account_$memory, $a_0)}(var $rsc := $ResourceValue($1_Account_Account_$memory, $a_0);
    (($IsValid'$1_Account_Account'($rsc) && ((LenVec($vec#$1_Option_Option'$1_Account_WithdrawCapability'($withdrawal_capability#$1_Account_Account($rsc))) <= 1) && (LenVec($vec#$1_Option_Option'$1_Account_KeyRotationCapability'($key_rotation_capability#$1_Account_Account($rsc))) <= 1))))));

    // assume forall $rsc: ResourceDomain<Account::Balance<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Account_Balance'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($1_Account_Balance'#0'_$memory, $a_0);
    ($IsValid'$1_Account_Balance'#0''($rsc))));

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:41:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[grantor]($t0) at ./sources/Vesting.move:41:5+1
    assume {:print "$track_local(30,0,0):", $t0} $t0 == $t0;

    // trace_local[amount]($t1) at ./sources/Vesting.move:41:5+1
    assume {:print "$track_local(30,0,1):", $t1} $t1 == $t1;

    // trace_local[beneficiary]($t2) at ./sources/Vesting.move:41:5+1
    assume {:print "$track_local(30,0,2):", $t2} $t2 == $t2;

    // trace_local[start]($t3) at ./sources/Vesting.move:41:5+1
    assume {:print "$track_local(30,0,3):", $t3} $t3 == $t3;

    // trace_local[duration]($t4) at ./sources/Vesting.move:41:5+1
    assume {:print "$track_local(30,0,4):", $t4} $t4 == $t4;

    // $t9 := exists<Vesting::Credentials<#0>>($t2) at ./sources/Vesting.move:43:17+6
    assume {:print "$at(22,1508,1514)"} true;
    $t9 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t2);

    // if ($t9) goto L0 else goto L1 at ./sources/Vesting.move:43:9+103
    if ($t9) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:43:9+103
L1:

    // destroy($t0) at ./sources/Vesting.move:43:9+103

    // $t10 := 3 at ./sources/Vesting.move:43:84+26
    $t10 := 3;
    assume $IsValid'u64'($t10);

    // $t11 := opaque begin: Errors::not_published($t10) at ./sources/Vesting.move:43:62+49

    // assume WellFormed($t11) at ./sources/Vesting.move:43:62+49
    assume $IsValid'u64'($t11);

    // assume Eq<u64>($t11, 5) at ./sources/Vesting.move:43:62+49
    assume $IsEqual'u64'($t11, 5);

    // $t11 := opaque end: Errors::not_published($t10) at ./sources/Vesting.move:43:62+49

    // trace_abort($t11) at ./sources/Vesting.move:43:9+103
    assume {:print "$at(22,1500,1603)"} true;
    assume {:print "$track_abort(30,0):", $t11} $t11 == $t11;

    // $t12 := move($t11) at ./sources/Vesting.move:43:9+103
    $t12 := $t11;

    // goto L10 at ./sources/Vesting.move:43:9+103
    goto L10;

    // label L0 at ./sources/Vesting.move:44:17+5
    assume {:print "$at(22,1621,1626)"} true;
L0:

    // $t13 := Timestamp::now_milliseconds() on_abort goto L10 with $t12 at ./sources/Vesting.move:44:26+29
    call $t13 := $1_Timestamp_now_milliseconds();
    if ($abort_flag) {
        assume {:print "$at(22,1630,1659)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // $t14 := >=($t3, $t13) at ./sources/Vesting.move:44:23+2
    call $t14 := $Ge($t3, $t13);

    // if ($t14) goto L2 else goto L3 at ./sources/Vesting.move:44:9+86
    if ($t14) { goto L2; } else { goto L3; }

    // label L3 at ./sources/Vesting.move:44:9+86
L3:

    // destroy($t0) at ./sources/Vesting.move:44:9+86

    // $t15 := 0 at ./sources/Vesting.move:44:72+21
    $t15 := 0;
    assume $IsValid'u64'($t15);

    // $t16 := opaque begin: Errors::custom($t15) at ./sources/Vesting.move:44:57+37

    // assume WellFormed($t16) at ./sources/Vesting.move:44:57+37
    assume $IsValid'u64'($t16);

    // assume Eq<u64>($t16, 255) at ./sources/Vesting.move:44:57+37
    assume $IsEqual'u64'($t16, 255);

    // $t16 := opaque end: Errors::custom($t15) at ./sources/Vesting.move:44:57+37

    // trace_abort($t16) at ./sources/Vesting.move:44:9+86
    assume {:print "$at(22,1613,1699)"} true;
    assume {:print "$track_abort(30,0):", $t16} $t16 == $t16;

    // $t12 := move($t16) at ./sources/Vesting.move:44:9+86
    $t12 := $t16;

    // goto L10 at ./sources/Vesting.move:44:9+86
    goto L10;

    // label L2 at ./sources/Vesting.move:45:64+7
    assume {:print "$at(22,1764,1771)"} true;
L2:

    // $t17 := opaque begin: Signer::address_of($t0) at ./sources/Vesting.move:45:45+27

    // assume WellFormed($t17) at ./sources/Vesting.move:45:45+27
    assume $IsValid'address'($t17);

    // assume Eq<address>($t17, Signer::$address_of($t0)) at ./sources/Vesting.move:45:45+27
    assume $IsEqual'address'($t17, $1_Signer_$address_of($t0));

    // $t17 := opaque end: Signer::address_of($t0) at ./sources/Vesting.move:45:45+27

    // $t18 := Account::balance<#0>($t17) on_abort goto L10 with $t12 at ./sources/Vesting.move:45:17+56
    call $t18 := $1_Account_balance'#0'($t17);
    if ($abort_flag) {
        assume {:print "$at(22,1717,1773)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // $t19 := >=($t18, $t1) at ./sources/Vesting.move:45:74+2
    call $t19 := $Ge($t18, $t1);

    // if ($t19) goto L4 else goto L5 at ./sources/Vesting.move:45:9+142
    if ($t19) { goto L4; } else { goto L5; }

    // label L5 at ./sources/Vesting.move:45:9+142
L5:

    // destroy($t0) at ./sources/Vesting.move:45:9+142

    // $t20 := 1 at ./sources/Vesting.move:46:40+24
    assume {:print "$at(22,1825,1849)"} true;
    $t20 := 1;
    assume $IsValid'u64'($t20);

    // $t21 := opaque begin: Errors::limit_exceeded($t20) at ./sources/Vesting.move:46:17+48

    // assume WellFormed($t21) at ./sources/Vesting.move:46:17+48
    assume $IsValid'u64'($t21);

    // assume Eq<u64>($t21, 8) at ./sources/Vesting.move:46:17+48
    assume $IsEqual'u64'($t21, 8);

    // $t21 := opaque end: Errors::limit_exceeded($t20) at ./sources/Vesting.move:46:17+48

    // trace_abort($t21) at ./sources/Vesting.move:45:9+142
    assume {:print "$at(22,1709,1851)"} true;
    assume {:print "$track_abort(30,0):", $t21} $t21 == $t21;

    // $t12 := move($t21) at ./sources/Vesting.move:45:9+142
    $t12 := $t21;

    // goto L10 at ./sources/Vesting.move:45:9+142
    goto L10;

    // label L4 at ./sources/Vesting.move:48:83+7
    assume {:print "$at(22,1944,1951)"} true;
L4:

    // $t22 := opaque begin: Signer::address_of($t0) at ./sources/Vesting.move:48:64+27

    // assume WellFormed($t22) at ./sources/Vesting.move:48:64+27
    assume $IsValid'address'($t22);

    // assume Eq<address>($t22, Signer::$address_of($t0)) at ./sources/Vesting.move:48:64+27
    assume $IsEqual'address'($t22, $1_Signer_$address_of($t0));

    // $t22 := opaque end: Signer::address_of($t0) at ./sources/Vesting.move:48:64+27

    // $t23 := Counter::has_counter<Counter::Counter<Vesting::MyCounter>>($t22) on_abort goto L10 with $t12 at ./sources/Vesting.move:48:14+78
    call $t23 := $6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter'$6ee3f577c8da207830c31e1f0abb4244_Counter_Counter'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter''($t22);
    if ($abort_flag) {
        assume {:print "$at(22,1875,1953)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // $t24 := !($t23) at ./sources/Vesting.move:48:13+1
    call $t24 := $Not($t23);

    // if ($t24) goto L6 else goto L8 at ./sources/Vesting.move:48:9+143
    if ($t24) { goto L6; } else { goto L8; }

    // label L6 at ./sources/Vesting.move:49:38+7
    assume {:print "$at(22,1994,2001)"} true;
L6:

    // Counter::init<Vesting::MyCounter>($t0) on_abort goto L10 with $t12 at ./sources/Vesting.move:49:13+33
    call $6ee3f577c8da207830c31e1f0abb4244_Counter_init'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'($t0);
    if ($abort_flag) {
        assume {:print "$at(22,1969,2002)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // label L8 at ./sources/Vesting.move:52:62+11
    assume {:print "$at(22,2077,2088)"} true;
L8:

    // $t25 := borrow_global<Vesting::Credentials<#0>>($t2) on_abort goto L10 with $t12 at ./sources/Vesting.move:52:20+17
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t2)) {
        call $ExecFailureAbort();
    } else {
        $t25 := $Mutation($Global($t2), EmptyVec(), $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t2));
    }
    if ($abort_flag) {
        assume {:print "$at(22,2035,2052)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // trace_local[cred]($t25) at ./sources/Vesting.move:52:13+4
    $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'' := $Dereference($t25);
    assume {:print "$track_local(30,0,7):", $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''} $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'' == $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'';

    // $t26 := Account::withdraw<#0>($t0, $t1) on_abort goto L10 with $t12 at ./sources/Vesting.move:53:21+45
    assume {:print "$at(22,2111,2156)"} true;
    call $t26 := $1_Account_withdraw'#0'($t0, $t1);
    if ($abort_flag) {
        assume {:print "$at(22,2111,2156)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // trace_local[token]($t26) at ./sources/Vesting.move:53:13+5
    assume {:print "$track_local(30,0,8):", $t26} $t26 == $t26;

    // $t27 := borrow_field<Vesting::Credentials<#0>>.token($t25) at ./sources/Vesting.move:54:35+15
    assume {:print "$at(22,2192,2207)"} true;
    $t27 := $ChildMutation($t25, 0, $token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t25)));

    // Token::deposit<#0>($t27, $t26) on_abort goto L10 with $t12 at ./sources/Vesting.move:54:9+49
    call $t27 := $1_Token_deposit'#0'($t27, $t26);
    if ($abort_flag) {
        assume {:print "$at(22,2166,2215)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // write_back[Reference($t25).token (Token::Token<#0>)]($t27) at ./sources/Vesting.move:54:9+49
    $t25 := $UpdateMutation($t25, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_token($Dereference($t25), $Dereference($t27)));

    // $t28 := borrow_field<Vesting::Credentials<#0>>.start($t25) at ./sources/Vesting.move:55:10+15
    assume {:print "$at(22,2226,2241)"} true;
    $t28 := $ChildMutation($t25, 1, $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t25)));

    // write_ref($t28, $t3) at ./sources/Vesting.move:55:9+24
    $t28 := $UpdateMutation($t28, $t3);

    // write_back[Reference($t25).start (u64)]($t28) at ./sources/Vesting.move:55:9+24
    $t25 := $UpdateMutation($t25, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_start($Dereference($t25), $Dereference($t28)));

    // $t29 := borrow_field<Vesting::Credentials<#0>>.duration($t25) at ./sources/Vesting.move:56:10+18
    assume {:print "$at(22,2260,2278)"} true;
    $t29 := $ChildMutation($t25, 2, $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t25)));

    // write_ref($t29, $t4) at ./sources/Vesting.move:56:9+30
    $t29 := $UpdateMutation($t29, $t4);

    // write_back[Reference($t25).duration (u64)]($t29) at ./sources/Vesting.move:56:9+30
    $t25 := $UpdateMutation($t25, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_duration($Dereference($t25), $Dereference($t29)));

    // trace_local[tmp#$6]($t0) at ./sources/Vesting.move:57:55+7
    assume {:print "$at(22,2345,2352)"} true;
    assume {:print "$track_local(30,0,6):", $t0} $t0 == $t0;

    // $t30 := false at ./sources/Vesting.move:57:65+11
    $t30 := false;
    assume $IsValid'bool'($t30);

    // $t31 := pack Vesting::MyCounter($t30) at ./sources/Vesting.move:57:65+11
    $t31 := $6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter($t30);

    // trace_local[tmp#$5]($t31) at ./sources/Vesting.move:57:65+11
    assume {:print "$track_local(30,0,5):", $t31} $t31 == $t31;

    // $t32 := Counter::increment<Vesting::MyCounter>($t0, $t31) on_abort goto L10 with $t12 at ./sources/Vesting.move:57:25+52
    call $t32 := $6ee3f577c8da207830c31e1f0abb4244_Counter_increment'$6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter'($t0, $t31);
    if ($abort_flag) {
        assume {:print "$at(22,2315,2367)"} true;
        $t12 := $abort_code;
        assume {:print "$track_abort(30,0):", $t12} $t12 == $t12;
        goto L10;
    }

    // $t33 := borrow_field<Vesting::Credentials<#0>>.id($t25) at ./sources/Vesting.move:57:10+12
    $t33 := $ChildMutation($t25, 3, $id#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t25)));

    // write_ref($t33, $t32) at ./sources/Vesting.move:57:9+68
    $t33 := $UpdateMutation($t33, $t32);

    // write_back[Reference($t25).id (u64)]($t33) at ./sources/Vesting.move:57:9+68
    $t25 := $UpdateMutation($t25, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_id($Dereference($t25), $Dereference($t33)));

    // $t34 := borrow_field<Vesting::Credentials<#0>>.total($t25) at ./sources/Vesting.move:58:10+15
    assume {:print "$at(22,2378,2393)"} true;
    $t34 := $ChildMutation($t25, 5, $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t25)));

    // write_ref($t34, $t1) at ./sources/Vesting.move:58:9+25
    $t34 := $UpdateMutation($t34, $t1);

    // write_back[Reference($t25).total (u128)]($t34) at ./sources/Vesting.move:58:9+25
    $t25 := $UpdateMutation($t25, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_total($Dereference($t25), $Dereference($t34)));

    // write_back[Vesting::Credentials<#0>@]($t25) at ./sources/Vesting.move:58:9+25
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory := $ResourceUpdate($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $GlobalLocationAddress($t25),
        $Dereference($t25));

    // label L9 at ./sources/Vesting.move:59:5+1
    assume {:print "$at(22,2408,2409)"} true;
L9:

    // return () at ./sources/Vesting.move:59:5+1
    return;

    // label L10 at ./sources/Vesting.move:59:5+1
L10:

    // abort($t12) at ./sources/Vesting.move:59:5+1
    $abort_code := $t12;
    $abort_flag := true;
    return;

}

// fun Vesting::start [verification] at ./sources/Vesting.move:73:5+247
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_start$verify(_$t0: int) returns ($ret0: int)
{
    // declare local variables
    var $t1: bool;
    var $t2: int;
    var $t3: int;
    var $t4: int;
    var $t5: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $t6: int;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'u64': int;
    $t0 := _$t0;

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:73:5+1
    assume {:print "$at(22,3110,3111)"} true;
    assume $IsValid'address'($t0);

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:73:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[addr]($t0) at ./sources/Vesting.move:73:5+1
    assume {:print "$track_local(30,5,0):", $t0} $t0 == $t0;

    // $t1 := exists<Vesting::Credentials<#0>>($t0) at ./sources/Vesting.move:74:17+6
    assume {:print "$at(22,3204,3210)"} true;
    $t1 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);

    // if ($t1) goto L0 else goto L1 at ./sources/Vesting.move:74:9+96
    if ($t1) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:74:77+26
L1:

    // $t2 := 3 at ./sources/Vesting.move:74:77+26
    $t2 := 3;
    assume $IsValid'u64'($t2);

    // $t3 := opaque begin: Errors::not_published($t2) at ./sources/Vesting.move:74:55+49

    // assume WellFormed($t3) at ./sources/Vesting.move:74:55+49
    assume $IsValid'u64'($t3);

    // assume Eq<u64>($t3, 5) at ./sources/Vesting.move:74:55+49
    assume $IsEqual'u64'($t3, 5);

    // $t3 := opaque end: Errors::not_published($t2) at ./sources/Vesting.move:74:55+49

    // trace_abort($t3) at ./sources/Vesting.move:74:9+96
    assume {:print "$at(22,3196,3292)"} true;
    assume {:print "$track_abort(30,5):", $t3} $t3 == $t3;

    // $t4 := move($t3) at ./sources/Vesting.move:74:9+96
    $t4 := $t3;

    // goto L3 at ./sources/Vesting.move:74:9+96
    goto L3;

    // label L0 at ./sources/Vesting.move:75:47+4
    assume {:print "$at(22,3340,3344)"} true;
L0:

    // $t5 := get_global<Vesting::Credentials<#0>>($t0) on_abort goto L3 with $t4 at ./sources/Vesting.move:75:9+13
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t5 := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(22,3302,3315)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(30,5):", $t4} $t4 == $t4;
        goto L3;
    }

    // $t6 := get_field<Vesting::Credentials<#0>>.start($t5) at ./sources/Vesting.move:75:9+49
    $t6 := $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($t5);

    // trace_return[0]($t6) at ./sources/Vesting.move:75:9+49
    assume {:print "$track_return(30,5,0):", $t6} $t6 == $t6;

    // label L2 at ./sources/Vesting.move:76:5+1
    assume {:print "$at(22,3356,3357)"} true;
L2:

    // return $t6 at ./sources/Vesting.move:76:5+1
    $ret0 := $t6;
    return;

    // label L3 at ./sources/Vesting.move:76:5+1
L3:

    // abort($t4) at ./sources/Vesting.move:76:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Vesting::do_accept_credentials [verification] at ./sources/Vesting.move:26:5+504
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_do_accept_credentials$verify(_$t0: $signer) returns ()
{
    // declare local variables
    var $t1: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $t2: int;
    var $t3: bool;
    var $t4: bool;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: $1_Token_Token'#0';
    var $t9: int;
    var $t10: int;
    var $t11: int;
    var $t12: int;
    var $t13: int;
    var $t14: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $t0: $signer;
    var $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'': $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $temp_0'signer': $signer;
    $t0 := _$t0;

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:26:5+1
    assume {:print "$at(22,755,756)"} true;
    assume $IsValid'signer'($t0) && $1_Signer_is_txn_signer($t0) && $1_Signer_is_txn_signer_addr($addr#$signer($t0));

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:26:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[beneficiary]($t0) at ./sources/Vesting.move:26:5+1
    assume {:print "$track_local(30,1,0):", $t0} $t0 == $t0;

    // $t2 := opaque begin: Signer::address_of($t0) at ./sources/Vesting.move:27:49+31
    assume {:print "$at(22,878,909)"} true;

    // assume WellFormed($t2) at ./sources/Vesting.move:27:49+31
    assume $IsValid'address'($t2);

    // assume Eq<address>($t2, Signer::$address_of($t0)) at ./sources/Vesting.move:27:49+31
    assume $IsEqual'address'($t2, $1_Signer_$address_of($t0));

    // $t2 := opaque end: Signer::address_of($t0) at ./sources/Vesting.move:27:49+31

    // $t3 := exists<Vesting::Credentials<#0>>($t2) at ./sources/Vesting.move:27:18+6
    $t3 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t2);

    // $t4 := !($t3) at ./sources/Vesting.move:27:17+1
    call $t4 := $Not($t3);

    // if ($t4) goto L0 else goto L1 at ./sources/Vesting.move:27:9+141
    if ($t4) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:27:9+141
L1:

    // destroy($t0) at ./sources/Vesting.move:27:9+141

    // $t5 := 2 at ./sources/Vesting.move:28:43+22
    assume {:print "$at(22,955,977)"} true;
    $t5 := 2;
    assume $IsValid'u64'($t5);

    // $t6 := opaque begin: Errors::already_published($t5) at ./sources/Vesting.move:28:17+49

    // assume WellFormed($t6) at ./sources/Vesting.move:28:17+49
    assume $IsValid'u64'($t6);

    // assume Eq<u64>($t6, 6) at ./sources/Vesting.move:28:17+49
    assume $IsEqual'u64'($t6, 6);

    // $t6 := opaque end: Errors::already_published($t5) at ./sources/Vesting.move:28:17+49

    // trace_abort($t6) at ./sources/Vesting.move:27:9+141
    assume {:print "$at(22,838,979)"} true;
    assume {:print "$track_abort(30,1):", $t6} $t6 == $t6;

    // $t7 := move($t6) at ./sources/Vesting.move:27:9+141
    $t7 := $t6;

    // goto L3 at ./sources/Vesting.move:27:9+141
    goto L3;

    // label L0 at ./sources/Vesting.move:30:20+24
    assume {:print "$at(22,1044,1068)"} true;
L0:

    // $t8 := Token::zero<#0>() on_abort goto L3 with $t7 at ./sources/Vesting.move:30:20+24
    call $t8 := $1_Token_zero'#0'();
    if ($abort_flag) {
        assume {:print "$at(22,1044,1068)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,1):", $t7} $t7 == $t7;
        goto L3;
    }

    // $t9 := 0 at ./sources/Vesting.move:31:20+1
    assume {:print "$at(22,1089,1090)"} true;
    $t9 := 0;
    assume $IsValid'u64'($t9);

    // $t10 := 0 at ./sources/Vesting.move:32:23+1
    assume {:print "$at(22,1114,1115)"} true;
    $t10 := 0;
    assume $IsValid'u64'($t10);

    // $t11 := 0 at ./sources/Vesting.move:33:17+1
    assume {:print "$at(22,1133,1134)"} true;
    $t11 := 0;
    assume $IsValid'u64'($t11);

    // $t12 := 0 at ./sources/Vesting.move:34:23+1
    assume {:print "$at(22,1158,1159)"} true;
    $t12 := 0;
    assume $IsValid'u128'($t12);

    // $t13 := 0 at ./sources/Vesting.move:35:20+1
    assume {:print "$at(22,1180,1181)"} true;
    $t13 := 0;
    assume $IsValid'u128'($t13);

    // $t14 := pack Vesting::Credentials<#0>($t8, $t9, $t10, $t11, $t12, $t13) at ./sources/Vesting.move:29:20+192
    assume {:print "$at(22,1000,1192)"} true;
    $t14 := $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($t8, $t9, $t10, $t11, $t12, $t13);

    // trace_local[cred]($t14) at ./sources/Vesting.move:29:13+4
    assume {:print "$track_local(30,1,1):", $t14} $t14 == $t14;

    // move_to<Vesting::Credentials<#0>>($t14, $t0) on_abort goto L3 with $t7 at ./sources/Vesting.move:37:9+7
    assume {:print "$at(22,1202,1209)"} true;
    if ($ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $addr#$signer($t0))) {
        call $ExecFailureAbort();
    } else {
        $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory := $ResourceUpdate($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $addr#$signer($t0), $t14);
    }
    if ($abort_flag) {
        assume {:print "$at(22,1202,1209)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,1):", $t7} $t7 == $t7;
        goto L3;
    }

    // label L2 at ./sources/Vesting.move:38:5+1
    assume {:print "$at(22,1258,1259)"} true;
L2:

    // return () at ./sources/Vesting.move:38:5+1
    return;

    // label L3 at ./sources/Vesting.move:38:5+1
L3:

    // abort($t7) at ./sources/Vesting.move:38:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

}

// fun Vesting::release [verification] at ./sources/Vesting.move:62:5+573
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_release$verify(_$t0: int) returns ()
{
    // declare local variables
    var $t1: $Mutation ($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0');
    var $t2: int;
    var $t3: int;
    var $t4: bool;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: $Mutation ($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0');
    var $t9: int;
    var $t10: int;
    var $t11: int;
    var $t12: int;
    var $t13: int;
    var $t14: int;
    var $t15: int;
    var $t16: int;
    var $t17: $Mutation (int);
    var $t18: $Mutation ($1_Token_Token'#0');
    var $t19: $1_Token_Token'#0';
    var $t0: int;
    var $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'': $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $temp_0'address': int;
    var $temp_0'u128': int;
    $t0 := _$t0;
    assume IsEmptyVec(p#$Mutation($t1));
    assume IsEmptyVec(p#$Mutation($t8));
    assume IsEmptyVec(p#$Mutation($t17));
    assume IsEmptyVec(p#$Mutation($t18));

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:62:5+1
    assume {:print "$at(22,2468,2469)"} true;
    assume $IsValid'address'($t0);

    // assume forall $rsc: ResourceDomain<Timestamp::CurrentTimeMilliseconds>(): WellFormed($rsc) at ./sources/Vesting.move:62:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0)}(var $rsc := $ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0);
    ($IsValid'$1_Timestamp_CurrentTimeMilliseconds'($rsc))));

    // assume forall $rsc: ResourceDomain<Account::Account>(): And(WellFormed($rsc), And(Le(Len<Account::WithdrawCapability>(select Option::Option.vec(select Account::Account.withdrawal_capability($rsc))), 1), Le(Len<Account::KeyRotationCapability>(select Option::Option.vec(select Account::Account.key_rotation_capability($rsc))), 1))) at ./sources/Vesting.move:62:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Account_Account_$memory, $a_0)}(var $rsc := $ResourceValue($1_Account_Account_$memory, $a_0);
    (($IsValid'$1_Account_Account'($rsc) && ((LenVec($vec#$1_Option_Option'$1_Account_WithdrawCapability'($withdrawal_capability#$1_Account_Account($rsc))) <= 1) && (LenVec($vec#$1_Option_Option'$1_Account_KeyRotationCapability'($key_rotation_capability#$1_Account_Account($rsc))) <= 1))))));

    // assume forall $rsc: ResourceDomain<Account::AutoAcceptToken>(): WellFormed($rsc) at ./sources/Vesting.move:62:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Account_AutoAcceptToken_$memory, $a_0)}(var $rsc := $ResourceValue($1_Account_AutoAcceptToken_$memory, $a_0);
    ($IsValid'$1_Account_AutoAcceptToken'($rsc))));

    // assume forall $rsc: ResourceDomain<Account::Balance<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:62:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Account_Balance'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($1_Account_Balance'#0'_$memory, $a_0);
    ($IsValid'$1_Account_Balance'#0''($rsc))));

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:62:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[beneficiary]($t0) at ./sources/Vesting.move:62:5+1
    assume {:print "$track_local(30,3,0):", $t0} $t0 == $t0;

    // $t4 := exists<Vesting::Credentials<#0>>($t0) at ./sources/Vesting.move:63:17+6
    assume {:print "$at(22,2566,2572)"} true;
    $t4 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);

    // if ($t4) goto L0 else goto L1 at ./sources/Vesting.move:63:9+103
    if ($t4) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:63:84+26
L1:

    // $t5 := 3 at ./sources/Vesting.move:63:84+26
    $t5 := 3;
    assume $IsValid'u64'($t5);

    // $t6 := opaque begin: Errors::not_published($t5) at ./sources/Vesting.move:63:62+49

    // assume WellFormed($t6) at ./sources/Vesting.move:63:62+49
    assume $IsValid'u64'($t6);

    // assume Eq<u64>($t6, 5) at ./sources/Vesting.move:63:62+49
    assume $IsEqual'u64'($t6, 5);

    // $t6 := opaque end: Errors::not_published($t5) at ./sources/Vesting.move:63:62+49

    // trace_abort($t6) at ./sources/Vesting.move:63:9+103
    assume {:print "$at(22,2558,2661)"} true;
    assume {:print "$track_abort(30,3):", $t6} $t6 == $t6;

    // $t7 := move($t6) at ./sources/Vesting.move:63:9+103
    $t7 := $t6;

    // goto L3 at ./sources/Vesting.move:63:9+103
    goto L3;

    // label L0 at ./sources/Vesting.move:64:62+11
    assume {:print "$at(22,2724,2735)"} true;
L0:

    // $t8 := borrow_global<Vesting::Credentials<#0>>($t0) on_abort goto L3 with $t7 at ./sources/Vesting.move:64:20+17
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t8 := $Mutation($Global($t0), EmptyVec(), $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0));
    }
    if ($abort_flag) {
        assume {:print "$at(22,2682,2699)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // trace_local[cred]($t8) at ./sources/Vesting.move:64:13+4
    $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'' := $Dereference($t8);
    assume {:print "$track_local(30,3,1):", $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''} $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'' == $temp_0'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'';

    // $t9 := get_field<Vesting::Credentials<#0>>.total($t8) at ./sources/Vesting.move:65:36+10
    assume {:print "$at(22,2773,2783)"} true;
    $t9 := $total#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8));

    // $t10 := get_field<Vesting::Credentials<#0>>.start($t8) at ./sources/Vesting.move:65:48+10
    $t10 := $start#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8));

    // $t11 := get_field<Vesting::Credentials<#0>>.duration($t8) at ./sources/Vesting.move:65:60+13
    $t11 := $duration#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8));

    // $t12 := Vesting::vested_amount($t9, $t10, $t11) on_abort goto L3 with $t7 at ./sources/Vesting.move:65:22+52
    call $t12 := $6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount($t9, $t10, $t11);
    if ($abort_flag) {
        assume {:print "$at(22,2759,2811)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // trace_local[vested]($t12) at ./sources/Vesting.move:65:13+6
    assume {:print "$track_local(30,3,3):", $t12} $t12 == $t12;

    // $t13 := get_field<Vesting::Credentials<#0>>.released($t8) at ./sources/Vesting.move:66:35+13
    assume {:print "$at(22,2847,2860)"} true;
    $t13 := $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8));

    // $t14 := -($t12, $t13) on_abort goto L3 with $t7 at ./sources/Vesting.move:66:33+1
    call $t14 := $Sub($t12, $t13);
    if ($abort_flag) {
        assume {:print "$at(22,2845,2846)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // trace_local[releasable]($t14) at ./sources/Vesting.move:66:13+10
    assume {:print "$track_local(30,3,2):", $t14} $t14 == $t14;

    // $t15 := get_field<Vesting::Credentials<#0>>.released($t8) at ./sources/Vesting.move:68:31+13
    assume {:print "$at(22,2901,2914)"} true;
    $t15 := $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8));

    // $t16 := +($t15, $t14) on_abort goto L3 with $t7 at ./sources/Vesting.move:68:45+1
    call $t16 := $AddU128($t15, $t14);
    if ($abort_flag) {
        assume {:print "$at(22,2915,2916)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // $t17 := borrow_field<Vesting::Credentials<#0>>.released($t8) at ./sources/Vesting.move:68:10+18
    $t17 := $ChildMutation($t8, 4, $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8)));

    // write_ref($t17, $t16) at ./sources/Vesting.move:68:9+48
    $t17 := $UpdateMutation($t17, $t16);

    // write_back[Reference($t8).released (u128)]($t17) at ./sources/Vesting.move:68:9+48
    $t8 := $UpdateMutation($t8, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_released($Dereference($t8), $Dereference($t17)));

    // $t18 := borrow_field<Vesting::Credentials<#0>>.token($t8) at ./sources/Vesting.move:69:77+15
    assume {:print "$at(22,3005,3020)"} true;
    $t18 := $ChildMutation($t8, 0, $token#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($Dereference($t8)));

    // $t19 := Token::withdraw<#0>($t18, $t14) on_abort goto L3 with $t7 at ./sources/Vesting.move:69:50+55
    call $t19,$t18 := $1_Token_withdraw'#0'($t18, $t14);
    if ($abort_flag) {
        assume {:print "$at(22,2978,3033)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // write_back[Reference($t8).token (Token::Token<#0>)]($t18) at ./sources/Vesting.move:69:50+55
    $t8 := $UpdateMutation($t8, $Update'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''_token($Dereference($t8), $Dereference($t18)));

    // write_back[Vesting::Credentials<#0>@]($t8) at ./sources/Vesting.move:69:50+55
    $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory := $ResourceUpdate($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $GlobalLocationAddress($t8),
        $Dereference($t8));

    // Account::deposit<#0>($t0, $t19) on_abort goto L3 with $t7 at ./sources/Vesting.move:69:9+97
    call $1_Account_deposit'#0'($t0, $t19);
    if ($abort_flag) {
        assume {:print "$at(22,2937,3034)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,3):", $t7} $t7 == $t7;
        goto L3;
    }

    // label L2 at ./sources/Vesting.move:70:5+1
    assume {:print "$at(22,3040,3041)"} true;
L2:

    // return () at ./sources/Vesting.move:70:5+1
    return;

    // label L3 at ./sources/Vesting.move:70:5+1
L3:

    // abort($t7) at ./sources/Vesting.move:70:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

}

// fun Vesting::released [verification] at ./sources/Vesting.move:85:5+254
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_released$verify(_$t0: int) returns ($ret0: int)
{
    // declare local variables
    var $t1: bool;
    var $t2: int;
    var $t3: int;
    var $t4: int;
    var $t5: $6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0';
    var $t6: int;
    var $t0: int;
    var $temp_0'address': int;
    var $temp_0'u128': int;
    $t0 := _$t0;

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:85:5+1
    assume {:print "$at(22,3728,3729)"} true;
    assume $IsValid'address'($t0);

    // assume forall $rsc: ResourceDomain<Vesting::Credentials<#0>>(): WellFormed($rsc) at ./sources/Vesting.move:85:5+1
    assume (forall $a_0: int :: {$ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0)}(var $rsc := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $a_0);
    ($IsValid'$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0''($rsc))));

    // trace_local[addr]($t0) at ./sources/Vesting.move:85:5+1
    assume {:print "$track_local(30,4,0):", $t0} $t0 == $t0;

    // $t1 := exists<Vesting::Credentials<#0>>($t0) at ./sources/Vesting.move:86:17+6
    assume {:print "$at(22,3826,3832)"} true;
    $t1 := $ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);

    // if ($t1) goto L0 else goto L1 at ./sources/Vesting.move:86:9+96
    if ($t1) { goto L0; } else { goto L1; }

    // label L1 at ./sources/Vesting.move:86:77+26
L1:

    // $t2 := 3 at ./sources/Vesting.move:86:77+26
    $t2 := 3;
    assume $IsValid'u64'($t2);

    // $t3 := opaque begin: Errors::not_published($t2) at ./sources/Vesting.move:86:55+49

    // assume WellFormed($t3) at ./sources/Vesting.move:86:55+49
    assume $IsValid'u64'($t3);

    // assume Eq<u64>($t3, 5) at ./sources/Vesting.move:86:55+49
    assume $IsEqual'u64'($t3, 5);

    // $t3 := opaque end: Errors::not_published($t2) at ./sources/Vesting.move:86:55+49

    // trace_abort($t3) at ./sources/Vesting.move:86:9+96
    assume {:print "$at(22,3818,3914)"} true;
    assume {:print "$track_abort(30,4):", $t3} $t3 == $t3;

    // $t4 := move($t3) at ./sources/Vesting.move:86:9+96
    $t4 := $t3;

    // goto L3 at ./sources/Vesting.move:86:9+96
    goto L3;

    // label L0 at ./sources/Vesting.move:87:47+4
    assume {:print "$at(22,3962,3966)"} true;
L0:

    // $t5 := get_global<Vesting::Credentials<#0>>($t0) on_abort goto L3 with $t4 at ./sources/Vesting.move:87:9+13
    if (!$ResourceExists($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0)) {
        call $ExecFailureAbort();
    } else {
        $t5 := $ResourceValue($6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'_$memory, $t0);
    }
    if ($abort_flag) {
        assume {:print "$at(22,3924,3937)"} true;
        $t4 := $abort_code;
        assume {:print "$track_abort(30,4):", $t4} $t4 == $t4;
        goto L3;
    }

    // $t6 := get_field<Vesting::Credentials<#0>>.released($t5) at ./sources/Vesting.move:87:9+52
    $t6 := $released#$6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials'#0'($t5);

    // trace_return[0]($t6) at ./sources/Vesting.move:87:9+52
    assume {:print "$track_return(30,4,0):", $t6} $t6 == $t6;

    // label L2 at ./sources/Vesting.move:88:5+1
    assume {:print "$at(22,3981,3982)"} true;
L2:

    // return $t6 at ./sources/Vesting.move:88:5+1
    $ret0 := $t6;
    return;

    // label L3 at ./sources/Vesting.move:88:5+1
L3:

    // abort($t4) at ./sources/Vesting.move:88:5+1
    $abort_code := $t4;
    $abort_flag := true;
    return;

}

// fun Vesting::vested_amount [baseline] at ./sources/Vesting.move:91:5+333
procedure {:inline 1} $6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount(_$t0: int, _$t1: int, _$t2: int) returns ($ret0: int)
{
    // declare local variables
    var $t3: int;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: bool;
    var $t9: int;
    var $t10: int;
    var $t11: bool;
    var $t12: int;
    var $t13: int;
    var $t14: int;
    var $t15: int;
    var $t16: bool;
    var $t0: int;
    var $t1: int;
    var $t2: int;
    var $temp_0'u128': int;
    var $temp_0'u64': int;
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;

    // bytecode translation starts here
    // trace_local[total]($t0) at ./sources/Vesting.move:91:5+1
    assume {:print "$at(22,4103,4104)"} true;
    assume {:print "$track_local(30,6,0):", $t0} $t0 == $t0;

    // trace_local[start]($t1) at ./sources/Vesting.move:91:5+1
    assume {:print "$track_local(30,6,1):", $t1} $t1 == $t1;

    // trace_local[duration]($t2) at ./sources/Vesting.move:91:5+1
    assume {:print "$track_local(30,6,2):", $t2} $t2 == $t2;

    // $t6 := Timestamp::now_milliseconds() on_abort goto L9 with $t7 at ./sources/Vesting.move:92:19+29
    assume {:print "$at(22,4187,4216)"} true;
    call $t6 := $1_Timestamp_now_milliseconds();
    if ($abort_flag) {
        assume {:print "$at(22,4187,4216)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // trace_local[now]($t6) at ./sources/Vesting.move:92:13+3
    assume {:print "$track_local(30,6,5):", $t6} $t6 == $t6;

    // $t8 := <($t6, $t1) at ./sources/Vesting.move:93:17+1
    assume {:print "$at(22,4234,4235)"} true;
    call $t8 := $Lt($t6, $t1);

    // if ($t8) goto L0 else goto L2 at ./sources/Vesting.move:93:9+204
    if ($t8) { goto L0; } else { goto L2; }

    // label L0 at ./sources/Vesting.move:94:13+5
    assume {:print "$at(22,4257,4262)"} true;
L0:

    // $t9 := 0 at ./sources/Vesting.move:94:13+5
    $t9 := 0;
    assume $IsValid'u128'($t9);

    // $t4 := $t9 at ./sources/Vesting.move:93:9+204
    assume {:print "$at(22,4226,4430)"} true;
    $t4 := $t9;

    // trace_local[tmp#$4]($t9) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_local(30,6,4):", $t9} $t9 == $t9;

    // goto L3 at ./sources/Vesting.move:93:9+204
    goto L3;

    // label L2 at ./sources/Vesting.move:95:20+3
    assume {:print "$at(22,4282,4285)"} true;
L2:

    // $t10 := +($t1, $t2) on_abort goto L9 with $t7 at ./sources/Vesting.move:95:32+1
    call $t10 := $AddU64($t1, $t2);
    if ($abort_flag) {
        assume {:print "$at(22,4294,4295)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t11 := >($t6, $t10) at ./sources/Vesting.move:95:24+1
    call $t11 := $Gt($t6, $t10);

    // if ($t11) goto L4 else goto L6 at ./sources/Vesting.move:95:16+152
    if ($t11) { goto L4; } else { goto L6; }

    // label L4 at ./sources/Vesting.move:96:13+5
    assume {:print "$at(22,4320,4325)"} true;
L4:

    // $t3 := $t0 at ./sources/Vesting.move:95:16+152
    assume {:print "$at(22,4278,4430)"} true;
    $t3 := $t0;

    // trace_local[tmp#$3]($t0) at ./sources/Vesting.move:95:16+152
    assume {:print "$track_local(30,6,3):", $t0} $t0 == $t0;

    // goto L7 at ./sources/Vesting.move:95:16+152
    goto L7;

    // label L6 at ./sources/Vesting.move:98:27+5
    assume {:print "$at(22,4369,4374)"} true;
L6:

    // $t12 := -($t6, $t1) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:40+1
    call $t12 := $Sub($t6, $t1);
    if ($abort_flag) {
        assume {:print "$at(22,4382,4383)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t13 := (u128)($t12) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:34+23
    call $t13 := $CastU128($t12);
    if ($abort_flag) {
        assume {:print "$at(22,4376,4399)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t14 := (u128)($t2) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:59+18
    call $t14 := $CastU128($t2);
    if ($abort_flag) {
        assume {:print "$at(22,4401,4419)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t15 := opaque begin: Math::mul_div($t0, $t13, $t14) at ./sources/Vesting.move:98:13+65

    // assume Identical($t16, Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(And(And(Neq<u128>($t13, $t14), Gt($t0, $t14)), Eq<u128>($t14, 0)), And(And(And(Neq<u128>($t13, $t14), Gt($t0, $t14)), Neq<u128>($t14, 0)), Gt(Mul(Div($t0, $t14), $t13), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Eq<u128>($t14, 0))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Div($t0, $t14), Mod($t0, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Div($t0, $t14), Mod($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mod($t0, $t14), Div($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mod($t0, $t14), Mod($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Div(Mul(Mod($t0, $t14), Mod($t13, $t14)), $t14), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), Mul(Mod($t0, $t14), Div($t13, $t14))), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Add(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), Mul(Mod($t0, $t14), Div($t13, $t14))), Div(Mul(Mod($t0, $t14), Mod($t13, $t14)), $t14)), 340282366920938463463374607431768211455))), false)) at ./sources/Vesting.move:98:13+65
    assume ($t16 == ((((((((((((((!$IsEqual'u128'($t13, $t14) && ($t0 > $t14)) && $IsEqual'u128'($t14, 0)) || (((!$IsEqual'u128'($t13, $t14) && ($t0 > $t14)) && !$IsEqual'u128'($t14, 0)) && ((($t0 div $t14) * $t13) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && $IsEqual'u128'($t14, 0))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 div $t14) * ($t0 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((($t0 div $t14) * ($t0 mod $t14)) * $t14) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 div $t14) * ($t13 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 mod $t14) * ($t13 div $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 mod $t14) * ($t13 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((($t0 mod $t14) * ($t13 mod $t14)) div $t14) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) + (($t0 mod $t14) * ($t13 div $t14))) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) + (($t0 mod $t14) * ($t13 div $t14))) + ((($t0 mod $t14) * ($t13 mod $t14)) div $t14)) > 340282366920938463463374607431768211455))) || false));

    // if ($t16) goto L11 else goto L10 at ./sources/Vesting.move:98:13+65
    if ($t16) { goto L11; } else { goto L10; }

    // label L11 at ./sources/Vesting.move:98:13+65
L11:

    // trace_abort($t7) at ./sources/Vesting.move:98:13+65
    assume {:print "$at(22,4355,4420)"} true;
    assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;

    // goto L9 at ./sources/Vesting.move:98:13+65
    goto L9;

    // label L10 at ./sources/Vesting.move:98:13+65
L10:

    // assume WellFormed($t15) at ./sources/Vesting.move:98:13+65
    assume $IsValid'u128'($t15);

    // assume Eq<u128>($t15, Math::spec_mul_div()) at ./sources/Vesting.move:98:13+65
    assume $IsEqual'u128'($t15, $1_Math_spec_mul_div());

    // $t15 := opaque end: Math::mul_div($t0, $t13, $t14) at ./sources/Vesting.move:98:13+65

    // $t3 := $t15 at ./sources/Vesting.move:95:16+152
    assume {:print "$at(22,4278,4430)"} true;
    $t3 := $t15;

    // trace_local[tmp#$3]($t15) at ./sources/Vesting.move:95:16+152
    assume {:print "$track_local(30,6,3):", $t15} $t15 == $t15;

    // label L7 at ./sources/Vesting.move:95:16+152
L7:

    // $t4 := $t3 at ./sources/Vesting.move:93:9+204
    assume {:print "$at(22,4226,4430)"} true;
    $t4 := $t3;

    // trace_local[tmp#$4]($t3) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_local(30,6,4):", $t3} $t3 == $t3;

    // label L3 at ./sources/Vesting.move:93:9+204
L3:

    // trace_return[0]($t4) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_return(30,6,0):", $t4} $t4 == $t4;

    // label L8 at ./sources/Vesting.move:100:5+1
    assume {:print "$at(22,4435,4436)"} true;
L8:

    // return $t4 at ./sources/Vesting.move:100:5+1
    $ret0 := $t4;
    return;

    // label L9 at ./sources/Vesting.move:100:5+1
L9:

    // abort($t7) at ./sources/Vesting.move:100:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

}

// fun Vesting::vested_amount [verification] at ./sources/Vesting.move:91:5+333
procedure {:timeLimit 40} $6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount$verify(_$t0: int, _$t1: int, _$t2: int) returns ($ret0: int)
{
    // declare local variables
    var $t3: int;
    var $t4: int;
    var $t5: int;
    var $t6: int;
    var $t7: int;
    var $t8: bool;
    var $t9: int;
    var $t10: int;
    var $t11: bool;
    var $t12: int;
    var $t13: int;
    var $t14: int;
    var $t15: int;
    var $t16: bool;
    var $t0: int;
    var $t1: int;
    var $t2: int;
    var $temp_0'u128': int;
    var $temp_0'u64': int;
    $t0 := _$t0;
    $t1 := _$t1;
    $t2 := _$t2;

    // verification entrypoint assumptions
    call $InitVerification();

    // bytecode translation starts here
    // assume WellFormed($t0) at ./sources/Vesting.move:91:5+1
    assume {:print "$at(22,4103,4104)"} true;
    assume $IsValid'u128'($t0);

    // assume WellFormed($t1) at ./sources/Vesting.move:91:5+1
    assume $IsValid'u64'($t1);

    // assume WellFormed($t2) at ./sources/Vesting.move:91:5+1
    assume $IsValid'u64'($t2);

    // assume forall $rsc: ResourceDomain<Timestamp::CurrentTimeMilliseconds>(): WellFormed($rsc) at ./sources/Vesting.move:91:5+1
    assume (forall $a_0: int :: {$ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0)}(var $rsc := $ResourceValue($1_Timestamp_CurrentTimeMilliseconds_$memory, $a_0);
    ($IsValid'$1_Timestamp_CurrentTimeMilliseconds'($rsc))));

    // trace_local[total]($t0) at ./sources/Vesting.move:91:5+1
    assume {:print "$track_local(30,6,0):", $t0} $t0 == $t0;

    // trace_local[start]($t1) at ./sources/Vesting.move:91:5+1
    assume {:print "$track_local(30,6,1):", $t1} $t1 == $t1;

    // trace_local[duration]($t2) at ./sources/Vesting.move:91:5+1
    assume {:print "$track_local(30,6,2):", $t2} $t2 == $t2;

    // $t6 := Timestamp::now_milliseconds() on_abort goto L9 with $t7 at ./sources/Vesting.move:92:19+29
    assume {:print "$at(22,4187,4216)"} true;
    call $t6 := $1_Timestamp_now_milliseconds();
    if ($abort_flag) {
        assume {:print "$at(22,4187,4216)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // trace_local[now]($t6) at ./sources/Vesting.move:92:13+3
    assume {:print "$track_local(30,6,5):", $t6} $t6 == $t6;

    // $t8 := <($t6, $t1) at ./sources/Vesting.move:93:17+1
    assume {:print "$at(22,4234,4235)"} true;
    call $t8 := $Lt($t6, $t1);

    // if ($t8) goto L0 else goto L2 at ./sources/Vesting.move:93:9+204
    if ($t8) { goto L0; } else { goto L2; }

    // label L0 at ./sources/Vesting.move:94:13+5
    assume {:print "$at(22,4257,4262)"} true;
L0:

    // $t9 := 0 at ./sources/Vesting.move:94:13+5
    $t9 := 0;
    assume $IsValid'u128'($t9);

    // $t4 := $t9 at ./sources/Vesting.move:93:9+204
    assume {:print "$at(22,4226,4430)"} true;
    $t4 := $t9;

    // trace_local[tmp#$4]($t9) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_local(30,6,4):", $t9} $t9 == $t9;

    // goto L3 at ./sources/Vesting.move:93:9+204
    goto L3;

    // label L2 at ./sources/Vesting.move:95:20+3
    assume {:print "$at(22,4282,4285)"} true;
L2:

    // $t10 := +($t1, $t2) on_abort goto L9 with $t7 at ./sources/Vesting.move:95:32+1
    call $t10 := $AddU64($t1, $t2);
    if ($abort_flag) {
        assume {:print "$at(22,4294,4295)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t11 := >($t6, $t10) at ./sources/Vesting.move:95:24+1
    call $t11 := $Gt($t6, $t10);

    // if ($t11) goto L4 else goto L6 at ./sources/Vesting.move:95:16+152
    if ($t11) { goto L4; } else { goto L6; }

    // label L4 at ./sources/Vesting.move:96:13+5
    assume {:print "$at(22,4320,4325)"} true;
L4:

    // $t3 := $t0 at ./sources/Vesting.move:95:16+152
    assume {:print "$at(22,4278,4430)"} true;
    $t3 := $t0;

    // trace_local[tmp#$3]($t0) at ./sources/Vesting.move:95:16+152
    assume {:print "$track_local(30,6,3):", $t0} $t0 == $t0;

    // goto L7 at ./sources/Vesting.move:95:16+152
    goto L7;

    // label L6 at ./sources/Vesting.move:98:27+5
    assume {:print "$at(22,4369,4374)"} true;
L6:

    // $t12 := -($t6, $t1) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:40+1
    call $t12 := $Sub($t6, $t1);
    if ($abort_flag) {
        assume {:print "$at(22,4382,4383)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t13 := (u128)($t12) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:34+23
    call $t13 := $CastU128($t12);
    if ($abort_flag) {
        assume {:print "$at(22,4376,4399)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t14 := (u128)($t2) on_abort goto L9 with $t7 at ./sources/Vesting.move:98:59+18
    call $t14 := $CastU128($t2);
    if ($abort_flag) {
        assume {:print "$at(22,4401,4419)"} true;
        $t7 := $abort_code;
        assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;
        goto L9;
    }

    // $t15 := opaque begin: Math::mul_div($t0, $t13, $t14) at ./sources/Vesting.move:98:13+65

    // assume Identical($t16, Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(Or(And(And(Neq<u128>($t13, $t14), Gt($t0, $t14)), Eq<u128>($t14, 0)), And(And(And(Neq<u128>($t13, $t14), Gt($t0, $t14)), Neq<u128>($t14, 0)), Gt(Mul(Div($t0, $t14), $t13), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Eq<u128>($t14, 0))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Div($t0, $t14), Mod($t0, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Div($t0, $t14), Mod($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mod($t0, $t14), Div($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Mul(Mod($t0, $t14), Mod($t13, $t14)), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Div(Mul(Mod($t0, $t14), Mod($t13, $t14)), $t14), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), Mul(Mod($t0, $t14), Div($t13, $t14))), 340282366920938463463374607431768211455))), And(And(Neq<u128>($t13, $t14), Le($t0, $t14)), Gt(Add(Add(Add(Mul(Mul(Div($t0, $t14), Mod($t0, $t14)), $t14), Mul(Div($t0, $t14), Mod($t13, $t14))), Mul(Mod($t0, $t14), Div($t13, $t14))), Div(Mul(Mod($t0, $t14), Mod($t13, $t14)), $t14)), 340282366920938463463374607431768211455))), false)) at ./sources/Vesting.move:98:13+65
    assume ($t16 == ((((((((((((((!$IsEqual'u128'($t13, $t14) && ($t0 > $t14)) && $IsEqual'u128'($t14, 0)) || (((!$IsEqual'u128'($t13, $t14) && ($t0 > $t14)) && !$IsEqual'u128'($t14, 0)) && ((($t0 div $t14) * $t13) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && $IsEqual'u128'($t14, 0))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 div $t14) * ($t0 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((($t0 div $t14) * ($t0 mod $t14)) * $t14) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 div $t14) * ($t13 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 mod $t14) * ($t13 div $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((($t0 mod $t14) * ($t13 mod $t14)) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((($t0 mod $t14) * ($t13 mod $t14)) div $t14) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && (((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) + (($t0 mod $t14) * ($t13 div $t14))) > 340282366920938463463374607431768211455))) || ((!$IsEqual'u128'($t13, $t14) && ($t0 <= $t14)) && ((((((($t0 div $t14) * ($t0 mod $t14)) * $t14) + (($t0 div $t14) * ($t13 mod $t14))) + (($t0 mod $t14) * ($t13 div $t14))) + ((($t0 mod $t14) * ($t13 mod $t14)) div $t14)) > 340282366920938463463374607431768211455))) || false));

    // if ($t16) goto L11 else goto L10 at ./sources/Vesting.move:98:13+65
    if ($t16) { goto L11; } else { goto L10; }

    // label L11 at ./sources/Vesting.move:98:13+65
L11:

    // trace_abort($t7) at ./sources/Vesting.move:98:13+65
    assume {:print "$at(22,4355,4420)"} true;
    assume {:print "$track_abort(30,6):", $t7} $t7 == $t7;

    // goto L9 at ./sources/Vesting.move:98:13+65
    goto L9;

    // label L10 at ./sources/Vesting.move:98:13+65
L10:

    // assume WellFormed($t15) at ./sources/Vesting.move:98:13+65
    assume $IsValid'u128'($t15);

    // assume Eq<u128>($t15, Math::spec_mul_div()) at ./sources/Vesting.move:98:13+65
    assume $IsEqual'u128'($t15, $1_Math_spec_mul_div());

    // $t15 := opaque end: Math::mul_div($t0, $t13, $t14) at ./sources/Vesting.move:98:13+65

    // $t3 := $t15 at ./sources/Vesting.move:95:16+152
    assume {:print "$at(22,4278,4430)"} true;
    $t3 := $t15;

    // trace_local[tmp#$3]($t15) at ./sources/Vesting.move:95:16+152
    assume {:print "$track_local(30,6,3):", $t15} $t15 == $t15;

    // label L7 at ./sources/Vesting.move:95:16+152
L7:

    // $t4 := $t3 at ./sources/Vesting.move:93:9+204
    assume {:print "$at(22,4226,4430)"} true;
    $t4 := $t3;

    // trace_local[tmp#$4]($t3) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_local(30,6,4):", $t3} $t3 == $t3;

    // label L3 at ./sources/Vesting.move:93:9+204
L3:

    // trace_return[0]($t4) at ./sources/Vesting.move:93:9+204
    assume {:print "$track_return(30,6,0):", $t4} $t4 == $t4;

    // label L8 at ./sources/Vesting.move:100:5+1
    assume {:print "$at(22,4435,4436)"} true;
L8:

    // return $t4 at ./sources/Vesting.move:100:5+1
    $ret0 := $t4;
    return;

    // label L9 at ./sources/Vesting.move:100:5+1
L9:

    // abort($t7) at ./sources/Vesting.move:100:5+1
    $abort_code := $t7;
    $abort_flag := true;
    return;

}
