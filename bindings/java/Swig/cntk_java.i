//
// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.md file in the project root for full license information.
//
// cntk_java.i -- SWIG Interface file for Java
//

//JNI defines UNUSED macro as well, undefining it so it doesn't conflict with CNTK's
%{
#undef UNUSED
%}

%{
    #pragma warning(disable : 4267) //warning C4267: 'initializing': conversion from 'size_t' to 'jsize', possible loss of data
%}

%include "CNTKManagedCommon.i"

%pragma(java) jniclasscode=%{
  static {
    String libName = "Cntk.Core.JavaBinding-2.0rc2";
    try {
       System.loadLibrary(libName);
    } catch (UnsatisfiedLinkError e) {
       try {
           System.loadLibrary(libName+'d');
       } catch (UnsatisfiedLinkError e2) {
          System.err.println("Native code library failed to load. \n" + e2);
          System.exit(1);
       }
    }
  }
%}

// Java specific extention.
%typemap(javacode) CNTK::DeviceDescriptor %{
    public DeviceKind getType() {
        return _Type();
    }

    public java.util.List<DeviceDescriptor> getAllDevices() {
        DeviceDescriptorVector devices = _AllDevices();
        java.util.ArrayList<DeviceDescriptor> ret = new java.util.ArrayList<DeviceDescriptor>((int)devices.size());
        for (int i = 0; i < devices.size(); ++i){
            ret.add(devices.get(i));
        }
        return ret;
    }

    public void setExcludedDevices(DeviceDescriptorVector ddv) {
        _SetExcludedDevices(ddv);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        DeviceDescriptor p = (DeviceDescriptor)o;
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    public boolean equals(DeviceDescriptor p) {
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    @Override
    public int hashCode() {
        return _Type().hashCode();
    }
%}

%typemap(javacode) CNTK::Axis %{

    public boolean isOrdered() {
        return _IsOrdered();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Axis p = (Axis)o;
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    public boolean equals(Axis p) {
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    @Override
    public int hashCode() {
        if (this.isDynamicAxis()) {
            return getName().hashCode();
        } else {
            return this.getStaticAxisIndex();
        }
    }
%}


%typemap(javacode) CNTK::Function %{

    public static Function load(byte[] modelBuffer, DeviceDescriptor computeDevice)
    {
        return load(modelBuffer, (long)modelBuffer.length, computeDevice);
    }

    // TODO: look at C# implementation and make it look more like that
    private VariableVector argumentVector;
    private VariableVector outputVector;
    private VariableVector inputVector;
    private java.util.ArrayList<Variable> argumentList;
    private java.util.ArrayList<Variable> outputList;
    private java.util.ArrayList<Variable> inputList;

    private UnorderedMapVariableValuePtr outMap = new UnorderedMapVariableValuePtr();

    public java.util.List<Variable> getInputs() {
        if (inputVector == null) {
            inputVector = _Inputs();
            inputList = new java.util.ArrayList<Variable>((int)inputVector.size());
            for (int i = 0; i < inputVector.size(); ++i){
                inputList.add(inputVector.get(i));
            }
        }
        return inputList;
    }

    public java.util.List<Variable> getOutputs() {
        if (outputVector == null) {
            outputVector = _Outputs();
            outputList = new java.util.ArrayList<Variable>((int)outputVector.size());
            for (int i = 0; i < outputVector.size(); ++i){
                outputList.add(outputVector.get(i));
            }
        }
        return outputList;
    }

    public java.util.List<Variable> getArguments() {
        if (argumentVector == null) {
            argumentVector = _Arguments();
            argumentList = new java.util.ArrayList<Variable>((int)argumentVector.size());
            for (int i = 0; i < argumentVector.size(); ++i){
                argumentList.add(argumentVector.get(i));
            }
        }
        return argumentList;
    }

    public boolean isComposite() {
        return _IsComposite();
    }

    public boolean isPrimitive() {
        return _IsPrimitive();
    }

    public boolean isBlock() {
        return _IsBlock();
    }

    public java.util.List<Function> findAllWithName(String name, boolean nestedSearchInsideBlockFunction) {
      FunctionPtrVector functions = _FindAllWithName(name, nestedSearchInsideBlockFunction);
      java.util.ArrayList<Function> ret = new java.util.ArrayList<Function>();
      for (int i = 0; i < functions.size(); ++i){
            ret.add(functions.get(i));
      }
      return ret;
    }

    public java.util.List<Function> findAllWithName(String name) {
      FunctionPtrVector functions = _FindAllWithName(name);
      java.util.ArrayList<Function> ret = new java.util.ArrayList<Function>();
      for (int i = 0; i < functions.size(); ++i){
            ret.add(functions.get(i));
      }
      return ret;
    }

    public java.util.List<Function> findAllWithUid(String uid, boolean nestedSearchInsideBlockFunction) {
      FunctionPtrVector functions = _FindAllWithUid(uid, nestedSearchInsideBlockFunction);
      java.util.ArrayList<Function> ret = new java.util.ArrayList<Function>();
      for (int i = 0; i < functions.size(); ++i){
            ret.add(functions.get(i));
      }
      return ret;
    }

    public java.util.List<Function> findAllWithUid(String uid) {
      FunctionPtrVector functions = _FindAllWithUid(uid);
      java.util.ArrayList<Function> ret = new java.util.ArrayList<Function>();
      for (int i = 0; i < functions.size(); ++i){
            ret.add(functions.get(i));
      }
      return ret;
    }

    public static Function combine(java.util.ArrayList<Variable> outputVariable) {
        VariableVector varVect = new VariableVector();
        for (int i = 0; i < outputVariable.size(); ++i)
        {
            varVect.add(varVect.get(i));
        }
        return CNTKLib.Combine(varVect);
    }

    public Function clone(VariableVector x) {
        return _Clone(x);
    }
%}

%typemap(javacode) CNTK::Variable %{

    public AxisVector getDynamicAxes() {
        return _DynamicAxes();
    }

    public boolean isSparse() {
        return _IsSparse();
    }

    public boolean isInput() {
        return _IsInput();
    }

    public boolean isOutput() {
        return _IsOutput();
    }

    public boolean isParameter() {
        return _IsParameter();
    }

    public boolean isConstant() {
        return _IsConstant();
    }

    public boolean isPlaceholder() {
        return _IsPlaceholder();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Variable p = (Variable)o;
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    public boolean equals(Variable p) {
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    @Override
    public int hashCode() {
        return (int)GetHashValue();
    }
%}

%typemap(javacode) CNTK::NDShape %{

    public boolean isUnknown() {
        return _IsUnknown();
    }

    public boolean hasInferredDimension() {
        return _HasInferredDimension();
    }

    public boolean hasFreeDimension() {
        return _HasFreeDimension();
    }

    public java.util.ArrayList<Long> getDimensions(){
        SizeTVector dimensions = _Dimensions();
        java.util.ArrayList<Long> ret = new java.util.ArrayList<Long>();
        for (int i = 0; i < dimensions.size(); ++i ) {
            ret.add((Long)dimensions.get(i));
        }
        return ret;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        NDShape p = (NDShape)o;
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    public boolean equals(NDShape p) {
        if (p == null) return false;
        return CNTKLib.AreEqual(this, p);
    }

    @Override
    public int hashCode() {
        return _Dimensions().hashCode();
    }
%}

%typemap(javacode) CNTK::NDMask %{

    public void invalidateSection(SizeTVector sectionOffset, NDShape sectionShape) {
        _InvalidateSection(sectionOffset, sectionShape);
    }

    public void markSequenceBegin(SizeTVector offset) {
        _MarkSequenceBegin(offset);
    }
%}

%typemap(javacode) CNTK::Value %{
    public boolean isReadOnly() {
        return _IsReadOnly();
    }
%}

%typemap(javacode) CNTK::NDArrayView %{
    public boolean isSparse() {
        return _IsSparse();
    }

    public boolean isReadOnly() {
        return _IsReadOnly();
    }

    public NDArrayView getSliceView(SizeTVector startOffset, SizeTVector extent) {
        return _SliceView(startOffset, extent);
    }
%}

%include "CNTKLibraryInternals.h"
%include "CNTKLibrary.h"