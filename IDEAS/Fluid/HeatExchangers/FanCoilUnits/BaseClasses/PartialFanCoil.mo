within IDEAS.Fluid.HeatExchangers.FanCoilUnits.BaseClasses;
partial model PartialFanCoil
  import Buildings;
  import IDEAS;

  package MediumAir = IDEAS.Media.Air;

  final parameter Modelica.SIunits.AbsolutePressure p = 101325 "pressure of the zone";

  final parameter MediumAir.ThermodynamicState staAir_default = MediumAir.setState_pTX(
     T=MediumAir.T_default,
     p=MediumAir.p_default,
     X=MediumAir.X_default[1:MediumAir.nXi]) "Default state for medium 2";

  final parameter Modelica.SIunits.HeatCapacity cpAir_nominal = MediumAir.specificHeatCapacityCp(staAir_default);

  parameter IDEAS.Fluid.HeatExchangers.FanCoilUnits.Types.FCUConfigurations configFCU;
  final parameter Boolean humidity = if configFCU == IDEAS.Fluid.HeatExchangers.FanCoilUnits.Types.FCUConfigurations.TwoPipeHea then false else true "parameter to know if compute humidity (only 2-pipe cooling and 4-pipe)";

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal
  "Nominal mass flow of the air stream";


  Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=true,
    use_Xi_in=humidity,
    p=100000)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mAir_flow_nominal,
    inputType=inputType,
    tau=0)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Sources.Boundary_pT sink(nPorts=1, redeclare package Medium = MediumAir)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,50})));



    Modelica.Blocks.Interfaces.IntegerInput stage if
       fan.inputType == IDEAS.Fluid.Types.InputType.Stages
    "Stage input signal for the pressure head"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,100})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s", nominal=
        mAir_flow_nominal) if
        fan.inputType == IDEAS.Fluid.Types.InputType.Continuous
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,100})));
  Modelica.Blocks.Interfaces.RealInput TAir(final unit="K",
                                                  displayUnit="degC")
    "Air temperature of the coupled zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-32,80})));
  Modelica.Blocks.Interfaces.RealInput phi if               humidity == true
    "Relative humidity of the zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-78,80})));

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_heat
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));

  parameter IDEAS.Fluid.Types.InputType inputType=IDEAS.Fluid.Types.InputType.Continuous
    "Fan control input type" annotation (Dialog(group="Fan parameters"));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"));
  IDEAS.Utilities.Psychrometrics.X_pTphi
                                   x_pTphi(use_p_in=false) if humidity == true
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-78,38})));
  IDEAS.Utilities.Psychrometrics.pW_X pWat(use_p_in=false) if humidity == true
    annotation (Placement(transformation(extent={{-88,-46},{-68,-26}})));
  IDEAS.Utilities.Psychrometrics.TDewPoi_pW dewPoi if humidity == true
    annotation (Placement(transformation(extent={{-62,-46},{-42,-26}})));
  IDEAS.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBul(
    redeclare package Medium = MediumAir) if humidity == true annotation (Placement(transformation(extent={{-40,58},{-20,78}})));
  Modelica.Blocks.Sources.Constant p_atm(k=p)
    annotation (Placement(transformation(extent={{-98,68},{-88,78}})));
  IDEAS.Utilities.Psychrometrics.X_pTphi x_pTphiSat(use_p_in=false) if humidity == true
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.Constant sat(k=1) if humidity == true
    annotation (Placement(transformation(extent={{-4,54},{6,64}})));
equation
  connect(bou.ports[1], fan.port_a)
    annotation (Line(points={{-68,0},{-50,0}}, color={0,127,255}));
  connect(bou.T_in, TAir) annotation (Line(points={{-90,4},{-92,4},{-92,56},{-50,
          56},{-50,100}}, color={0,0,127}));
  connect(m_flow_in, fan.m_flow_in) annotation (Line(points={{60,100},{60,40},{-40,
          40},{-40,12}}, color={0,0,127}));
  connect(stage, fan.stage);
  connect(x_pTphi.X, bou.Xi_in) annotation (Line(points={{-78,27},{-78,18},{-96,
          18},{-96,-4},{-90,-4}}, color={0,0,127}));
  connect(x_pTphi.phi, phi) annotation (Line(points={{-84,50},{-84,62},{-80,62},
          {-80,100}}, color={0,0,127}));
  connect(TAir, x_pTphi.T) annotation (Line(points={{-50,100},{-50,56},{-78,56},
          {-78,50}}, color={0,0,127}));
  connect(pWat.p_w, dewPoi.p_w)
    annotation (Line(points={{-67,-36},{-63,-36}}, color={0,0,127}));
  connect(bou.Xi_in[1], pWat.X_w) annotation (Line(points={{-90,-4},{-96,-4},{-96,
          -36},{-89,-36}}, color={0,0,127}));
  connect(TAir, wetBul.TDryBul)
    annotation (Line(points={{-50,100},{-50,76},{-41,76}}, color={0,0,127}));
  connect(phi, wetBul.phi)
    annotation (Line(points={{-80,100},{-80,68},{-41,68}}, color={0,0,127}));
  connect(p_atm.y, wetBul.p) annotation (Line(points={{-87.5,73},{-82,73},{-82,60},
          {-41,60}}, color={0,0,127}));
  connect(sat.y, x_pTphiSat.phi) annotation (Line(points={{6.5,59},{10.25,59},{10.25,
          64},{18,64}}, color={0,0,127}));
  connect(dewPoi.T, x_pTphiSat.T) annotation (Line(points={{-41,-36},{-34,-36},{
          -34,-20},{-60,-20},{-60,48},{-10,48},{-10,70},{18,70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,40},{100,-60}},
          lineColor={0,0,0},
          radius=10),
          Rectangle(
          extent={{-92,-8},{92,-54}},
          lineColor={0,0,0},
          radius=10,
          lineThickness=0.5),
          Rectangle(
          extent={{-92,34},{-36,0}},
          lineColor={0,0,0},
          radius=10,
          lineThickness=0.5),
          Rectangle(
          extent={{36,34},{92,0}},
          lineColor={0,0,0},
          radius=10,
          lineThickness=0.5),
          Rectangle(
          extent={{-28,34},{28,0}},
          lineColor={0,0,0},
          radius=10,
          lineThickness=0.5),
        Line(
          points={{-84,26},{-44,26}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-84,10},{-44,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,26},{20,26}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,10},{20,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{44,26},{84,26}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{44,10},{84,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-84,-16},{84,-16}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-84,-30},{84,-30}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-84,-44},{84,-44}},
          color={0,0,0},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFanCoil;