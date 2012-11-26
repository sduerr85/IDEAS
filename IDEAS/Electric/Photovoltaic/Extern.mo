within IDEAS.Electric.Photovoltaic;
package Extern

     extends Modelica.Icons.Package;

  model PvSystemPlug
    "PV system with separate shut-down controller and plug connector"

  parameter Modelica.SIunits.Power PNom "Nominal power, in Wp";
  parameter Integer PV=19
      "Which photovoltaic from the read profiles in the SimInfoManager";

  parameter Modelica.SIunits.Time timeOff = 300;
  parameter Modelica.SIunits.Voltage VMax = 253
      "Max grid voltage for operation of the PV system";
  parameter Integer numPha=1;
  //output Real PInit;
  //output Real PFinal;

  replaceable Components.PvVoltageCtrlGeneral_InputVGrid
                         pvVoltageCtrl(VMax=VMax,timeOff = timeOff,numPha=numPha) annotation (Placement(transformation(extent={{20,30},{40,50}})),choicesAllMatching = true);

    Modelica.Blocks.Interfaces.RealInput VGrid
      annotation (Placement(transformation(extent={{-116,30},{-96,50}})));
    Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plug(m=numPha)                                                                               annotation (Placement(transformation(extent={{90,30},
              {110,50}},                                                                                                    rotation=0)));

    IDEAS.Electric.Photovoltaic.Components.ForInputFiles.SimpleDCAC_effP invertor(PNom=-
          PNom, P_dc_max=-PNom)
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));
    BaseClasses.WattsLawPlug wattsLaw(numPha=numPha)
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
    outer SimInfoManager sim
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    Modelica.Blocks.Sources.RealExpression PDc(y=sim.tabPPV.y[PV]/sim.PNom*PNom)
      annotation (Placement(transformation(extent={{-80,70},{-40,90}})));
  equation

    connect(wattsLaw.vi, plug) annotation (Line(
        points={{80,40},{100,40}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(pvVoltageCtrl.PFinal, wattsLaw.P[1]) annotation (Line(
        points={{40.6,46},{60,46}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pvVoltageCtrl.QFinal, wattsLaw.Q[1]) annotation (Line(
        points={{40.6,42},{60,42}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(invertor.P, pvVoltageCtrl.PInit) annotation (Line(
        points={{0.6,46},{20.2,46}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(invertor.Q, pvVoltageCtrl.QInit) annotation (Line(
        points={{0.4,42},{20.2,42}},
        color={0,0,127},
        smooth=Smooth.None));
  // PInit=pvVoltageCtrl.PInit;
  // PFinal=pvVoltageCtrl.PFinal;
    connect(pvVoltageCtrl.VGrid, VGrid) annotation (Line(
        points={{30,30},{30,22},{-40,22},{-40,40},{-106,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(PDc.y, invertor.P_dc) annotation (Line(
        points={{-38,80},{-32,80},{-32,40},{-19.8,40}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Icon(graphics={
          Polygon(
            points={{-80,60},{-60,80},{60,80},{80,60},{80,-60},{60,-80},{-60,-80},
                {-80,-60},{-80,60}},
            lineColor={0,0,0},
            smooth=Smooth.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-40,80},{-40,-80}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{40,80},{40,-80}},
            color={0,0,0},
            smooth=Smooth.None),
          Text(
            extent={{-80,80},{80,-80}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="#")}),                                                                  Diagram(
          graphics));
  end PvSystemPlug;
end Extern;