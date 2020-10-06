Name: "Root"
RootId: 4781671109827199097
Objects {
  Id: 4781671109827199097
  Name: "Root"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ChildIds: 9702398848862610955
  ChildIds: 7367735074338159388
  ChildIds: 16813558807825262224
  ChildIds: 11471710598079691502
  ChildIds: 14713340454944924967
  ChildIds: 6826436379014069217
  ChildIds: 11504432768120143721
  ChildIds: 5666405351775097228
  ChildIds: 10914247158698788748
  ChildIds: 8206587631497182582
  ChildIds: 9131728340401120455
  ChildIds: 6862748695550464527
  ChildIds: 18320808188208391474
  ChildIds: 8096458904255746710
  ChildIds: 13231938497781083742
  ChildIds: 16800268766816622620
  ChildIds: 11223694863034159572
  ChildIds: 15961653796888257940
  ChildIds: 6803715026257547553
  ChildIds: 4006365592851178976
  ChildIds: 5057709256497919050
  ChildIds: 9949078653840365239
  ChildIds: 14443978946760639511
  ChildIds: 14456092487949735464
  ChildIds: 10401435904006163214
  ChildIds: 5336363324787038691
  ChildIds: 11974001358700662557
  ChildIds: 8122734062243750572
  ChildIds: 1427362885633459115
  ChildIds: 10459698034509544222
  ChildIds: 11469302847311806131
  ChildIds: 12894929396934667989
  ChildIds: 4801457059757967285
  ChildIds: 11225576373258822780
  ChildIds: 3059071086228792302
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:forceon"
  }
  Folder {
  }
}
Objects {
  Id: 3059071086228792302
  Name: "MovingPlatform"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  WantsNetworking: true
  TemplateInstance {
    ParameterOverrideMap {
      key: 2671395276593627741
      value {
        Overrides {
          Name: "Name"
          String: "MovingPlatform"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 8321.67
            Y: -4647.49658
            Z: 388.642822
          }
        }
        Overrides {
          Name: "StaticMesh"
          AssetReference {
            Id: 7144363769242365623
          }
        }
        Overrides {
          Name: "ma:Shared_BaseMaterial:id"
          AssetReference {
            Id: 5021787745358976968
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
            Yaw: -90
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 11916254025430631207
      value {
        Overrides {
          Name: "cs:TimeToTravel"
          Float: 4
        }
        Overrides {
          Name: "cs:Offset"
          Vector {
            Y: -2800
          }
        }
      }
    }
    TemplateAsset {
      Id: 2357647169488416784
    }
  }
}
Objects {
  Id: 11225576373258822780
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 5283.93555
      Y: -7760.09277
      Z: 393.006348
    }
    Rotation {
    }
    Scale {
      X: 2.81439042
      Y: 2.81439042
      Z: 2.81439042
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 6895.93066
            Y: -7760.09277
            Z: 393.006348
          }
        }
        Overrides {
          Name: "cs:ActivationTime"
          Float: 0.5
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 2.81439042
            Y: 2.81439042
            Z: 2.81439042
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 4801457059757967285
  Name: "Scoreboard"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 3772104818986187317
      value {
        Overrides {
          Name: "Name"
          String: "Scoreboard"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 4906.34863
            Y: -5455.86719
            Z: 591.384338
          }
        }
        Overrides {
          Name: "cs:Binding"
          String: "ability_extra_19"
        }
      }
    }
    TemplateAsset {
      Id: 15623951097497420140
    }
  }
}
Objects {
  Id: 12894929396934667989
  Name: "Decorations"
  Transform {
    Location {
      X: 5325
      Y: -7775
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsFilePartition: true
    FilePartitionName: "Decorations"
  }
}
Objects {
  Id: 11469302847311806131
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 3900
      Y: 375
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 2950
            Y: 375
            Z: 425
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1.5
            Y: 1.5
            Z: 1.5
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 10459698034509544222
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 3900
      Y: 25
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 2950
            Y: 25
            Z: 425
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1.5
            Y: 1.5
            Z: 1.5
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 1427362885633459115
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 5283.93555
      Y: -7760.09277
      Z: 387.922241
    }
    Rotation {
    }
    Scale {
      X: 2.81439042
      Y: 2.81439042
      Z: 2.81439042
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 6075
            Y: -7760.09277
            Z: 393.006348
          }
        }
        Overrides {
          Name: "cs:ActivationTime"
          Float: 0.5
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 2.81439042
            Y: 2.81439042
            Z: 2.81439042
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 8122734062243750572
  Name: "SpikeTrap"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 5283.93555
            Y: -7760.09277
            Z: 393.006348
          }
        }
        Overrides {
          Name: "cs:ActivationTime"
          Float: 0.5
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 2.81439042
            Y: 2.81439042
            Z: 2.81439042
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 11974001358700662557
  Name: "Kill Zone"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 13591331349196528036
      value {
        Overrides {
          Name: "Scale"
          Vector {
            X: 10.0000019
            Y: 44
            Z: 1
          }
        }
        Overrides {
          Name: "Position"
          Vector {
            Z: 100
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 13648825478633622894
      value {
        Overrides {
          Name: "Name"
          String: "Kill Zone"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 4625
            Y: -2925
            Z: -1925
          }
        }
      }
    }
    TemplateAsset {
      Id: 7064774221429051261
    }
  }
}
Objects {
  Id: 5336363324787038691
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 4775
      Y: -3675
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 12411709061285600638
  ChildIds: 4591974195272559592
  ChildIds: 13545212929719260247
  ChildIds: 17117538000044220261
  UnregisteredParameters {
    Overrides {
      Name: "cs:ActivationTime"
      Float: 0.5
    }
    Overrides {
      Name: "cs:Damage"
      Float: 100
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 1797290644650089856
    SubobjectId: 4149476347164763570
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
    WasRoot: true
  }
}
Objects {
  Id: 17117538000044220261
  Name: "Geo"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 5336363324787038691
  ChildIds: 13221978365923297719
  ChildIds: 8332252310535167857
  ChildIds: 14432511092374194530
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 2909794586764432728
    SubobjectId: 649941473375464810
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14432511092374194530
  Name: "SpikeTrapClient"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 17117538000044220261
  UnregisteredParameters {
    Overrides {
      Name: "cs:Offset"
      Vector {
        Z: 70
      }
    }
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 13545212929719260247
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 5336363324787038691
      }
    }
    Overrides {
      Name: "cs:SpikeVisuals"
      ObjectReference {
        SelfId: 8332252310535167857
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3209970125726946835
    }
  }
  InstanceHistory {
    SelfId: 17004084539103494570
    SubobjectId: 14600107432418851224
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8332252310535167857
  Name: "SpikeVisuals"
  Transform {
    Location {
      Z: -80
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 17117538000044220261
  ChildIds: 13367690829970832067
  ChildIds: 929061653224115206
  ChildIds: 12523082724305325957
  ChildIds: 16610526318840949085
  ChildIds: 801714176501341406
  ChildIds: 13767939305854812684
  ChildIds: 3916776117178899850
  ChildIds: 1317490963295707398
  ChildIds: 6867155056905393284
  ChildIds: 4142514034296801531
  ChildIds: 6986552332382826040
  ChildIds: 6919124221505486599
  ChildIds: 7792028634177480055
  ChildIds: 18163473676818333299
  ChildIds: 17782081842991239883
  ChildIds: 11633520911338281422
  ChildIds: 17808549476831086150
  ChildIds: 9217943185350612795
  ChildIds: 12132425134166015797
  ChildIds: 16234411763920424950
  ChildIds: 5794927485729811118
  ChildIds: 1655689146399083657
  ChildIds: 3720123181826792407
  ChildIds: 3842411801622538790
  ChildIds: 11797310297401076439
  ChildIds: 10680440037527288751
  ChildIds: 2744137927824467413
  ChildIds: 10024366823558045051
  ChildIds: 11079754792460396838
  ChildIds: 8121986754471604389
  ChildIds: 1858308279415957400
  ChildIds: 16536552883454945932
  ChildIds: 12435287145493654061
  ChildIds: 6383834607159931315
  ChildIds: 15994567921906662940
  ChildIds: 6932202383502551269
  ChildIds: 10424513268199027492
  ChildIds: 1388098555578392100
  ChildIds: 9973543231076736616
  ChildIds: 14833997790542175506
  ChildIds: 7902343395593778966
  ChildIds: 8159114293383905907
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 16039953726478252130
    SubobjectId: 18446172874404528208
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8159114293383905907
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5749687279038267741
    SubobjectId: 7975411551228983663
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7902343395593778966
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17898941777036124386
    SubobjectId: 15636907095138719952
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14833997790542175506
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4906317735804578406
    SubobjectId: 7309933103163691604
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9973543231076736616
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 953943035089278442
    SubobjectId: 3195781895725002200
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1388098555578392100
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13031074158491971707
    SubobjectId: 10786974838846900297
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10424513268199027492
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14406282736945663335
    SubobjectId: 16612021195404571989
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6932202383502551269
  Name: "Cone"
  Transform {
    Location {
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2651206114834806263
    SubobjectId: 409367399825280453
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15994567921906662940
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5213136153137723242
    SubobjectId: 7583044882640490328
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6383834607159931315
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15514904617666239029
    SubobjectId: 17740988576192274951
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12435287145493654061
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 413571361577500664
    SubobjectId: 2655408985669994442
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16536552883454945932
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2685320253167037796
    SubobjectId: 297387228878509398
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1858308279415957400
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3374836465432272221
    SubobjectId: 1130816318946436463
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8121986754471604389
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10890371022283120310
    SubobjectId: 13134460445781976708
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11079754792460396838
  Name: "Cone"
  Transform {
    Location {
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4937576382014088024
    SubobjectId: 7341271042254084970
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10024366823558045051
  Name: "Cone"
  Transform {
    Location {
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 251160903106939311
    SubobjectId: 2456969867346293149
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2744137927824467413
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11832668965829635799
    SubobjectId: 9606935750846453477
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10680440037527288751
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15768025467096558049
    SubobjectId: 18138215680971772371
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11797310297401076439
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1117909601668406413
    SubobjectId: 3379731948834776255
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3842411801622538790
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14907308091323983593
    SubobjectId: 17259413537672421083
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3720123181826792407
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5130523478632315426
    SubobjectId: 7374613031517045264
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1655689146399083657
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18236131129488205493
    SubobjectId: 15886276392568102535
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5794927485729811118
  Name: "Cone"
  Transform {
    Location {
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8023231190675611630
    SubobjectId: 5637551065985034204
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16234411763920424950
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6309093081168452513
    SubobjectId: 8568874734887887763
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12132425134166015797
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1437900877791379145
    SubobjectId: 3643649232258090747
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9217943185350612795
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14331467090370923444
    SubobjectId: 16683371455213663110
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17808549476831086150
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6108543538570702310
    SubobjectId: 8476130099516134868
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11633520911338281422
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12142864829794916971
    SubobjectId: 9935147121154384473
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17782081842991239883
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4073510318343930452
    SubobjectId: 1868044538499775078
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18163473676818333299
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15149889112225258484
    SubobjectId: 17535771684762215366
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7792028634177480055
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11170987329567173254
    SubobjectId: 13430848285696447156
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6919124221505486599
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13316887070653080979
    SubobjectId: 11073140565932547489
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6986552332382826040
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7275099484420454678
    SubobjectId: 5013347505327718692
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4142514034296801531
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16050620013197368198
    SubobjectId: 18436581621319852980
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6867155056905393284
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17413196766505442287
    SubobjectId: 15045610058864780253
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1317490963295707398
  Name: "Cone"
  Transform {
    Location {
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11590326245730017764
    SubobjectId: 9348831669135317462
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3916776117178899850
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18360760496388373085
    SubobjectId: 16116732653325288047
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13767939305854812684
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5530768698460251950
    SubobjectId: 7900888534464519964
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 801714176501341406
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1345540252204961093
    SubobjectId: 3731501860193760631
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16610526318840949085
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1673346278232402281
    SubobjectId: 3917092646323474779
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12523082724305325957
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4059293893522299838
    SubobjectId: 1815274847357068172
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 929061653224115206
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11271334980048747725
    SubobjectId: 13623239215232386303
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13367690829970832067
  Name: "Cone"
  Transform {
    Location {
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 8332252310535167857
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4573044551307105675
    SubobjectId: 2166815653532954041
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13221978365923297719
  Name: "Cube"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 0.25
    }
  }
  ParentId: 17117538000044220261
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 12095835209017042614
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12759500020211041001
    SubobjectId: 10409645283022519003
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13545212929719260247
  Name: "Trigger"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 1
    }
  }
  ParentId: 5336363324787038691
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 9734114137893278699
    SubobjectId: 11993685785562377177
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4591974195272559592
  Name: "SpikeTrapServer"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 5336363324787038691
  UnregisteredParameters {
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 13545212929719260247
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 5336363324787038691
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 4233072502576864937
    }
  }
  InstanceHistory {
    SelfId: 11304262192293148288
    SubobjectId: 13656156532816383666
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12411709061285600638
  Name: "Fantasy Castle Floor 01 4m"
  Transform {
    Location {
      X: -100
      Y: 100
      Z: 16.6666679
    }
    Rotation {
    }
    Scale {
      X: 0.5
      Y: 0.5
      Z: 0.5
    }
  }
  ParentId: 5336363324787038691
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10223008057381932438
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 10401435904006163214
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 4475
      Y: -3150
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 8559785652725586525
  ChildIds: 12735015063161946468
  ChildIds: 5115451720458026466
  ChildIds: 9672954397257755059
  UnregisteredParameters {
    Overrides {
      Name: "cs:ActivationTime"
      Float: 1
    }
    Overrides {
      Name: "cs:Damage"
      Float: 100
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 1797290644650089856
    SubobjectId: 4149476347164763570
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
    WasRoot: true
  }
}
Objects {
  Id: 9672954397257755059
  Name: "Geo"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 10401435904006163214
  ChildIds: 18428675532000181106
  ChildIds: 14029903093668262100
  ChildIds: 9632284987795609367
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 2909794586764432728
    SubobjectId: 649941473375464810
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9632284987795609367
  Name: "SpikeTrapClient"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 9672954397257755059
  UnregisteredParameters {
    Overrides {
      Name: "cs:Offset"
      Vector {
        Z: 70
      }
    }
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 5115451720458026466
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 10401435904006163214
      }
    }
    Overrides {
      Name: "cs:SpikeVisuals"
      ObjectReference {
        SelfId: 14029903093668262100
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3209970125726946835
    }
  }
  InstanceHistory {
    SelfId: 17004084539103494570
    SubobjectId: 14600107432418851224
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14029903093668262100
  Name: "SpikeVisuals"
  Transform {
    Location {
      Z: -80
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 9672954397257755059
  ChildIds: 15040559488555007824
  ChildIds: 4767581851454603589
  ChildIds: 10619843697690882415
  ChildIds: 11123268659729891022
  ChildIds: 16199203277445758071
  ChildIds: 2951273460240093952
  ChildIds: 12641806384387485526
  ChildIds: 15097353373467943139
  ChildIds: 12003313311931497651
  ChildIds: 5444804756315365388
  ChildIds: 14538098951264260544
  ChildIds: 18401590048168239086
  ChildIds: 12429394143894555229
  ChildIds: 16469599434094649862
  ChildIds: 6673421743714533108
  ChildIds: 12077120410020465326
  ChildIds: 2608292955638052544
  ChildIds: 4325688400336922074
  ChildIds: 7547372797593735950
  ChildIds: 13022392927897125655
  ChildIds: 1442902261195789956
  ChildIds: 9572884612309073910
  ChildIds: 9825217671329800328
  ChildIds: 18141061604463467257
  ChildIds: 7109148800225496187
  ChildIds: 3454147046973246771
  ChildIds: 15474352078342790550
  ChildIds: 2555817308229324493
  ChildIds: 9998308101000376407
  ChildIds: 5627208746896030495
  ChildIds: 5478949836029920241
  ChildIds: 15026173496044978085
  ChildIds: 14325832773547163769
  ChildIds: 17424053054210948849
  ChildIds: 3013181851022642527
  ChildIds: 10285738486055393768
  ChildIds: 13228966084870641016
  ChildIds: 6820823012672756279
  ChildIds: 17355821403946785893
  ChildIds: 6294075956932801092
  ChildIds: 5718808510568525178
  ChildIds: 7171414609223179015
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 16039953726478252130
    SubobjectId: 18446172874404528208
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7171414609223179015
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5749687279038267741
    SubobjectId: 7975411551228983663
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5718808510568525178
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17898941777036124386
    SubobjectId: 15636907095138719952
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6294075956932801092
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4906317735804578406
    SubobjectId: 7309933103163691604
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17355821403946785893
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 953943035089278442
    SubobjectId: 3195781895725002200
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6820823012672756279
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13031074158491971707
    SubobjectId: 10786974838846900297
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13228966084870641016
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14406282736945663335
    SubobjectId: 16612021195404571989
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10285738486055393768
  Name: "Cone"
  Transform {
    Location {
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2651206114834806263
    SubobjectId: 409367399825280453
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3013181851022642527
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5213136153137723242
    SubobjectId: 7583044882640490328
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17424053054210948849
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15514904617666239029
    SubobjectId: 17740988576192274951
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14325832773547163769
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 413571361577500664
    SubobjectId: 2655408985669994442
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15026173496044978085
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2685320253167037796
    SubobjectId: 297387228878509398
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5478949836029920241
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3374836465432272221
    SubobjectId: 1130816318946436463
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5627208746896030495
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10890371022283120310
    SubobjectId: 13134460445781976708
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9998308101000376407
  Name: "Cone"
  Transform {
    Location {
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4937576382014088024
    SubobjectId: 7341271042254084970
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2555817308229324493
  Name: "Cone"
  Transform {
    Location {
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 251160903106939311
    SubobjectId: 2456969867346293149
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15474352078342790550
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11832668965829635799
    SubobjectId: 9606935750846453477
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3454147046973246771
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15768025467096558049
    SubobjectId: 18138215680971772371
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7109148800225496187
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1117909601668406413
    SubobjectId: 3379731948834776255
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18141061604463467257
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14907308091323983593
    SubobjectId: 17259413537672421083
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9825217671329800328
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5130523478632315426
    SubobjectId: 7374613031517045264
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9572884612309073910
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18236131129488205493
    SubobjectId: 15886276392568102535
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1442902261195789956
  Name: "Cone"
  Transform {
    Location {
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8023231190675611630
    SubobjectId: 5637551065985034204
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13022392927897125655
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6309093081168452513
    SubobjectId: 8568874734887887763
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7547372797593735950
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1437900877791379145
    SubobjectId: 3643649232258090747
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4325688400336922074
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14331467090370923444
    SubobjectId: 16683371455213663110
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2608292955638052544
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6108543538570702310
    SubobjectId: 8476130099516134868
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12077120410020465326
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12142864829794916971
    SubobjectId: 9935147121154384473
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6673421743714533108
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4073510318343930452
    SubobjectId: 1868044538499775078
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16469599434094649862
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15149889112225258484
    SubobjectId: 17535771684762215366
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12429394143894555229
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11170987329567173254
    SubobjectId: 13430848285696447156
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18401590048168239086
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13316887070653080979
    SubobjectId: 11073140565932547489
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14538098951264260544
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7275099484420454678
    SubobjectId: 5013347505327718692
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5444804756315365388
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16050620013197368198
    SubobjectId: 18436581621319852980
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12003313311931497651
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17413196766505442287
    SubobjectId: 15045610058864780253
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15097353373467943139
  Name: "Cone"
  Transform {
    Location {
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11590326245730017764
    SubobjectId: 9348831669135317462
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12641806384387485526
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18360760496388373085
    SubobjectId: 16116732653325288047
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2951273460240093952
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5530768698460251950
    SubobjectId: 7900888534464519964
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16199203277445758071
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1345540252204961093
    SubobjectId: 3731501860193760631
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11123268659729891022
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1673346278232402281
    SubobjectId: 3917092646323474779
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10619843697690882415
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4059293893522299838
    SubobjectId: 1815274847357068172
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4767581851454603589
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11271334980048747725
    SubobjectId: 13623239215232386303
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15040559488555007824
  Name: "Cone"
  Transform {
    Location {
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 14029903093668262100
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4573044551307105675
    SubobjectId: 2166815653532954041
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18428675532000181106
  Name: "Cube"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 0.25
    }
  }
  ParentId: 9672954397257755059
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 12095835209017042614
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12759500020211041001
    SubobjectId: 10409645283022519003
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5115451720458026466
  Name: "Trigger"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 1
    }
  }
  ParentId: 10401435904006163214
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 9734114137893278699
    SubobjectId: 11993685785562377177
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12735015063161946468
  Name: "SpikeTrapServer"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 10401435904006163214
  UnregisteredParameters {
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 5115451720458026466
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 10401435904006163214
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 4233072502576864937
    }
  }
  InstanceHistory {
    SelfId: 11304262192293148288
    SubobjectId: 13656156532816383666
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8559785652725586525
  Name: "Fantasy Castle Floor 01 4m"
  Transform {
    Location {
      X: -100
      Y: 100
      Z: 16.6666679
    }
    Rotation {
    }
    Scale {
      X: 0.5
      Y: 0.5
      Z: 0.5
    }
  }
  ParentId: 10401435904006163214
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10223008057381932438
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 14456092487949735464
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 4600
      Y: -2700
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 10891813586198008922
  ChildIds: 6200887715707842243
  ChildIds: 11720755738241568285
  ChildIds: 15321485598367064667
  UnregisteredParameters {
    Overrides {
      Name: "cs:ActivationTime"
      Float: 1
    }
    Overrides {
      Name: "cs:Damage"
      Float: 100
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 1797290644650089856
    SubobjectId: 4149476347164763570
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
    WasRoot: true
  }
}
Objects {
  Id: 15321485598367064667
  Name: "Geo"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14456092487949735464
  ChildIds: 3452792398313987465
  ChildIds: 12737973712763013690
  ChildIds: 1621821335006261991
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 2909794586764432728
    SubobjectId: 649941473375464810
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1621821335006261991
  Name: "SpikeTrapClient"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 15321485598367064667
  UnregisteredParameters {
    Overrides {
      Name: "cs:Offset"
      Vector {
        Z: 70
      }
    }
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 11720755738241568285
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 14456092487949735464
      }
    }
    Overrides {
      Name: "cs:SpikeVisuals"
      ObjectReference {
        SelfId: 12737973712763013690
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3209970125726946835
    }
  }
  InstanceHistory {
    SelfId: 17004084539103494570
    SubobjectId: 14600107432418851224
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12737973712763013690
  Name: "SpikeVisuals"
  Transform {
    Location {
      Z: -80
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 15321485598367064667
  ChildIds: 7586458568652948145
  ChildIds: 8374608898862750694
  ChildIds: 4947032566061019231
  ChildIds: 9425211747078162691
  ChildIds: 16083469894214843540
  ChildIds: 12822624224562665832
  ChildIds: 9703440312584494486
  ChildIds: 1144989963342297167
  ChildIds: 13700205911694443245
  ChildIds: 13873696585241426377
  ChildIds: 9181210602338439476
  ChildIds: 4958772401709120103
  ChildIds: 15892524380310128488
  ChildIds: 4380554495436445709
  ChildIds: 16914576123868693392
  ChildIds: 1208603525135040245
  ChildIds: 17661958598900717115
  ChildIds: 16977169263792705160
  ChildIds: 10322056446533056202
  ChildIds: 8074618764251466068
  ChildIds: 1833415148093827200
  ChildIds: 9618759469448391611
  ChildIds: 2599625972739283322
  ChildIds: 13352541086526408103
  ChildIds: 8292770817526235299
  ChildIds: 798125958770672852
  ChildIds: 17378705367375195823
  ChildIds: 2110996775353737964
  ChildIds: 14107245846294464367
  ChildIds: 7515836291331265340
  ChildIds: 10347625002913981675
  ChildIds: 7049508974876914994
  ChildIds: 1196230346148384689
  ChildIds: 1602247376345937390
  ChildIds: 8857239791336843744
  ChildIds: 6993303614492078545
  ChildIds: 13824003846880739398
  ChildIds: 16126424313487835231
  ChildIds: 2963570424625480227
  ChildIds: 14862103558105500431
  ChildIds: 11344432841938733207
  ChildIds: 3375160257409456861
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 16039953726478252130
    SubobjectId: 18446172874404528208
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3375160257409456861
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5749687279038267741
    SubobjectId: 7975411551228983663
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11344432841938733207
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17898941777036124386
    SubobjectId: 15636907095138719952
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14862103558105500431
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4906317735804578406
    SubobjectId: 7309933103163691604
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2963570424625480227
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 953943035089278442
    SubobjectId: 3195781895725002200
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16126424313487835231
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13031074158491971707
    SubobjectId: 10786974838846900297
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13824003846880739398
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14406282736945663335
    SubobjectId: 16612021195404571989
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6993303614492078545
  Name: "Cone"
  Transform {
    Location {
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2651206114834806263
    SubobjectId: 409367399825280453
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8857239791336843744
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5213136153137723242
    SubobjectId: 7583044882640490328
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1602247376345937390
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15514904617666239029
    SubobjectId: 17740988576192274951
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1196230346148384689
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 413571361577500664
    SubobjectId: 2655408985669994442
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7049508974876914994
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2685320253167037796
    SubobjectId: 297387228878509398
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10347625002913981675
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3374836465432272221
    SubobjectId: 1130816318946436463
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7515836291331265340
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10890371022283120310
    SubobjectId: 13134460445781976708
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14107245846294464367
  Name: "Cone"
  Transform {
    Location {
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4937576382014088024
    SubobjectId: 7341271042254084970
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2110996775353737964
  Name: "Cone"
  Transform {
    Location {
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 251160903106939311
    SubobjectId: 2456969867346293149
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17378705367375195823
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11832668965829635799
    SubobjectId: 9606935750846453477
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 798125958770672852
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15768025467096558049
    SubobjectId: 18138215680971772371
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8292770817526235299
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1117909601668406413
    SubobjectId: 3379731948834776255
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13352541086526408103
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14907308091323983593
    SubobjectId: 17259413537672421083
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2599625972739283322
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5130523478632315426
    SubobjectId: 7374613031517045264
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9618759469448391611
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18236131129488205493
    SubobjectId: 15886276392568102535
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1833415148093827200
  Name: "Cone"
  Transform {
    Location {
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8023231190675611630
    SubobjectId: 5637551065985034204
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8074618764251466068
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6309093081168452513
    SubobjectId: 8568874734887887763
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10322056446533056202
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1437900877791379145
    SubobjectId: 3643649232258090747
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16977169263792705160
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14331467090370923444
    SubobjectId: 16683371455213663110
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17661958598900717115
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6108543538570702310
    SubobjectId: 8476130099516134868
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1208603525135040245
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12142864829794916971
    SubobjectId: 9935147121154384473
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16914576123868693392
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4073510318343930452
    SubobjectId: 1868044538499775078
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4380554495436445709
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15149889112225258484
    SubobjectId: 17535771684762215366
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15892524380310128488
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11170987329567173254
    SubobjectId: 13430848285696447156
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4958772401709120103
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13316887070653080979
    SubobjectId: 11073140565932547489
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9181210602338439476
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7275099484420454678
    SubobjectId: 5013347505327718692
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13873696585241426377
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16050620013197368198
    SubobjectId: 18436581621319852980
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13700205911694443245
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17413196766505442287
    SubobjectId: 15045610058864780253
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1144989963342297167
  Name: "Cone"
  Transform {
    Location {
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11590326245730017764
    SubobjectId: 9348831669135317462
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9703440312584494486
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18360760496388373085
    SubobjectId: 16116732653325288047
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12822624224562665832
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5530768698460251950
    SubobjectId: 7900888534464519964
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16083469894214843540
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1345540252204961093
    SubobjectId: 3731501860193760631
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9425211747078162691
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1673346278232402281
    SubobjectId: 3917092646323474779
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4947032566061019231
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4059293893522299838
    SubobjectId: 1815274847357068172
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8374608898862750694
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11271334980048747725
    SubobjectId: 13623239215232386303
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7586458568652948145
  Name: "Cone"
  Transform {
    Location {
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 12737973712763013690
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4573044551307105675
    SubobjectId: 2166815653532954041
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3452792398313987465
  Name: "Cube"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 0.25
    }
  }
  ParentId: 15321485598367064667
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 12095835209017042614
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12759500020211041001
    SubobjectId: 10409645283022519003
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11720755738241568285
  Name: "Trigger"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 1
    }
  }
  ParentId: 14456092487949735464
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 9734114137893278699
    SubobjectId: 11993685785562377177
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6200887715707842243
  Name: "SpikeTrapServer"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14456092487949735464
  UnregisteredParameters {
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 11720755738241568285
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 14456092487949735464
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 4233072502576864937
    }
  }
  InstanceHistory {
    SelfId: 11304262192293148288
    SubobjectId: 13656156532816383666
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10891813586198008922
  Name: "Fantasy Castle Floor 01 4m"
  Transform {
    Location {
      X: -100
      Y: 100
      Z: 16.6666679
    }
    Rotation {
    }
    Scale {
      X: 0.5
      Y: 0.5
      Z: 0.5
    }
  }
  ParentId: 14456092487949735464
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10223008057381932438
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 14443978946760639511
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 4775
      Y: -2100
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 17104196150621420914
  ChildIds: 9518173443849421375
  ChildIds: 2500419306089830010
  ChildIds: 6889840819912749462
  UnregisteredParameters {
    Overrides {
      Name: "cs:ActivationTime"
      Float: 1
    }
    Overrides {
      Name: "cs:Damage"
      Float: 100
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 1797290644650089856
    SubobjectId: 4149476347164763570
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
    WasRoot: true
  }
}
Objects {
  Id: 6889840819912749462
  Name: "Geo"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14443978946760639511
  ChildIds: 9146141783717982505
  ChildIds: 5144187254863988711
  ChildIds: 6940028057599646921
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 2909794586764432728
    SubobjectId: 649941473375464810
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6940028057599646921
  Name: "SpikeTrapClient"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 6889840819912749462
  UnregisteredParameters {
    Overrides {
      Name: "cs:Offset"
      Vector {
        Z: 70
      }
    }
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 2500419306089830010
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 14443978946760639511
      }
    }
    Overrides {
      Name: "cs:SpikeVisuals"
      ObjectReference {
        SelfId: 5144187254863988711
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3209970125726946835
    }
  }
  InstanceHistory {
    SelfId: 17004084539103494570
    SubobjectId: 14600107432418851224
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5144187254863988711
  Name: "SpikeVisuals"
  Transform {
    Location {
      Z: -80
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 6889840819912749462
  ChildIds: 6105932359239422989
  ChildIds: 18282688814754720760
  ChildIds: 7548976616491390687
  ChildIds: 9143835808441000262
  ChildIds: 17165785922438156116
  ChildIds: 1920364491420709091
  ChildIds: 7251296536445343786
  ChildIds: 3612099583864022869
  ChildIds: 4247336048266204029
  ChildIds: 13578185860508830134
  ChildIds: 6697367561581542564
  ChildIds: 6394906075215787209
  ChildIds: 18377801792037881855
  ChildIds: 13731601656540905525
  ChildIds: 10594718277535167232
  ChildIds: 2742918715906771409
  ChildIds: 13586505313706457099
  ChildIds: 15929113688297490868
  ChildIds: 12080901025573440798
  ChildIds: 14940868392766807962
  ChildIds: 1694461609330364001
  ChildIds: 2802446549252793425
  ChildIds: 7608586717743380840
  ChildIds: 10077551329019386311
  ChildIds: 16339860505951479617
  ChildIds: 12510119063301978670
  ChildIds: 8756602501629894678
  ChildIds: 15600292076906502038
  ChildIds: 6635011066631668503
  ChildIds: 15823330084553390138
  ChildIds: 7984715158293929897
  ChildIds: 9786745899649301977
  ChildIds: 17463615874633671686
  ChildIds: 8690555057422240848
  ChildIds: 8187199668069556814
  ChildIds: 11185872689343204483
  ChildIds: 6412181939724974355
  ChildIds: 1306555047092994571
  ChildIds: 2686312284102125744
  ChildIds: 3453585433920232579
  ChildIds: 6124284824410134592
  ChildIds: 4057443832221534138
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 16039953726478252130
    SubobjectId: 18446172874404528208
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4057443832221534138
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5749687279038267741
    SubobjectId: 7975411551228983663
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6124284824410134592
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17898941777036124386
    SubobjectId: 15636907095138719952
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3453585433920232579
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4906317735804578406
    SubobjectId: 7309933103163691604
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2686312284102125744
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 953943035089278442
    SubobjectId: 3195781895725002200
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1306555047092994571
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13031074158491971707
    SubobjectId: 10786974838846900297
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6412181939724974355
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14406282736945663335
    SubobjectId: 16612021195404571989
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11185872689343204483
  Name: "Cone"
  Transform {
    Location {
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2651206114834806263
    SubobjectId: 409367399825280453
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8187199668069556814
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5213136153137723242
    SubobjectId: 7583044882640490328
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8690555057422240848
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15514904617666239029
    SubobjectId: 17740988576192274951
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17463615874633671686
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 413571361577500664
    SubobjectId: 2655408985669994442
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9786745899649301977
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2685320253167037796
    SubobjectId: 297387228878509398
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7984715158293929897
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3374836465432272221
    SubobjectId: 1130816318946436463
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15823330084553390138
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10890371022283120310
    SubobjectId: 13134460445781976708
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6635011066631668503
  Name: "Cone"
  Transform {
    Location {
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4937576382014088024
    SubobjectId: 7341271042254084970
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15600292076906502038
  Name: "Cone"
  Transform {
    Location {
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 251160903106939311
    SubobjectId: 2456969867346293149
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8756602501629894678
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11832668965829635799
    SubobjectId: 9606935750846453477
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12510119063301978670
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15768025467096558049
    SubobjectId: 18138215680971772371
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16339860505951479617
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1117909601668406413
    SubobjectId: 3379731948834776255
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10077551329019386311
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14907308091323983593
    SubobjectId: 17259413537672421083
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7608586717743380840
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5130523478632315426
    SubobjectId: 7374613031517045264
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2802446549252793425
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18236131129488205493
    SubobjectId: 15886276392568102535
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1694461609330364001
  Name: "Cone"
  Transform {
    Location {
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8023231190675611630
    SubobjectId: 5637551065985034204
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14940868392766807962
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6309093081168452513
    SubobjectId: 8568874734887887763
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12080901025573440798
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1437900877791379145
    SubobjectId: 3643649232258090747
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15929113688297490868
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14331467090370923444
    SubobjectId: 16683371455213663110
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13586505313706457099
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6108543538570702310
    SubobjectId: 8476130099516134868
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2742918715906771409
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12142864829794916971
    SubobjectId: 9935147121154384473
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 10594718277535167232
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4073510318343930452
    SubobjectId: 1868044538499775078
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13731601656540905525
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15149889112225258484
    SubobjectId: 17535771684762215366
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18377801792037881855
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11170987329567173254
    SubobjectId: 13430848285696447156
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6394906075215787209
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13316887070653080979
    SubobjectId: 11073140565932547489
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6697367561581542564
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7275099484420454678
    SubobjectId: 5013347505327718692
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13578185860508830134
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16050620013197368198
    SubobjectId: 18436581621319852980
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4247336048266204029
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17413196766505442287
    SubobjectId: 15045610058864780253
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3612099583864022869
  Name: "Cone"
  Transform {
    Location {
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11590326245730017764
    SubobjectId: 9348831669135317462
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7251296536445343786
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18360760496388373085
    SubobjectId: 16116732653325288047
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1920364491420709091
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5530768698460251950
    SubobjectId: 7900888534464519964
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17165785922438156116
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1345540252204961093
    SubobjectId: 3731501860193760631
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9143835808441000262
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1673346278232402281
    SubobjectId: 3917092646323474779
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7548976616491390687
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4059293893522299838
    SubobjectId: 1815274847357068172
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18282688814754720760
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11271334980048747725
    SubobjectId: 13623239215232386303
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6105932359239422989
  Name: "Cone"
  Transform {
    Location {
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 5144187254863988711
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4573044551307105675
    SubobjectId: 2166815653532954041
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9146141783717982505
  Name: "Cube"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 0.25
    }
  }
  ParentId: 6889840819912749462
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 12095835209017042614
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12759500020211041001
    SubobjectId: 10409645283022519003
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2500419306089830010
  Name: "Trigger"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 1
    }
  }
  ParentId: 14443978946760639511
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 9734114137893278699
    SubobjectId: 11993685785562377177
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9518173443849421375
  Name: "SpikeTrapServer"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14443978946760639511
  UnregisteredParameters {
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 2500419306089830010
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 14443978946760639511
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 4233072502576864937
    }
  }
  InstanceHistory {
    SelfId: 11304262192293148288
    SubobjectId: 13656156532816383666
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17104196150621420914
  Name: "Fantasy Castle Floor 01 4m"
  Transform {
    Location {
      X: -100
      Y: 100
      Z: 16.6666679
    }
    Rotation {
    }
    Scale {
      X: 0.5
      Y: 0.5
      Z: 0.5
    }
  }
  ParentId: 14443978946760639511
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10223008057381932438
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 9949078653840365239
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 4775
      Y: -1625
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1.5
      Y: 1.5
      Z: 1.5
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 8348016030753923362
  ChildIds: 9152915530480671407
  ChildIds: 7958916465235984201
  ChildIds: 14614037832803765177
  UnregisteredParameters {
    Overrides {
      Name: "cs:ActivationTime"
      Float: 1
    }
    Overrides {
      Name: "cs:Damage"
      Float: 100
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 1797290644650089856
    SubobjectId: 4149476347164763570
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
    WasRoot: true
  }
}
Objects {
  Id: 14614037832803765177
  Name: "Geo"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 9949078653840365239
  ChildIds: 18147056077240695194
  ChildIds: 3109853297689081498
  ChildIds: 13679797915342908897
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 2909794586764432728
    SubobjectId: 649941473375464810
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13679797915342908897
  Name: "SpikeTrapClient"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14614037832803765177
  UnregisteredParameters {
    Overrides {
      Name: "cs:Offset"
      Vector {
        Z: 70
      }
    }
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 7958916465235984201
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 9949078653840365239
      }
    }
    Overrides {
      Name: "cs:SpikeVisuals"
      ObjectReference {
        SelfId: 3109853297689081498
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3209970125726946835
    }
  }
  InstanceHistory {
    SelfId: 17004084539103494570
    SubobjectId: 14600107432418851224
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3109853297689081498
  Name: "SpikeVisuals"
  Transform {
    Location {
      Z: -80
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14614037832803765177
  ChildIds: 18397479859347564633
  ChildIds: 579097832131304695
  ChildIds: 16217949309078767354
  ChildIds: 4949124530701803776
  ChildIds: 16468113041274862262
  ChildIds: 17241301015851726063
  ChildIds: 6819587533114199461
  ChildIds: 7072342247494432109
  ChildIds: 17440352619188588579
  ChildIds: 3294193931879272178
  ChildIds: 12721023197908404817
  ChildIds: 15250021899506479110
  ChildIds: 17020605518031085918
  ChildIds: 15302688570313093088
  ChildIds: 12979515632470679598
  ChildIds: 5057665816307221324
  ChildIds: 9817696278949288064
  ChildIds: 5197863348278240053
  ChildIds: 2359653447951393509
  ChildIds: 17375679705368486414
  ChildIds: 9469719214498564796
  ChildIds: 14674253902104820312
  ChildIds: 1621452080594853775
  ChildIds: 4397640758044087374
  ChildIds: 13910519904598083903
  ChildIds: 17645112947854547505
  ChildIds: 3418713158656861367
  ChildIds: 1789933635180683525
  ChildIds: 17372308155002170148
  ChildIds: 3981120372859470673
  ChildIds: 15334481297929791313
  ChildIds: 6673665673209086385
  ChildIds: 17679166974480841356
  ChildIds: 544320408982192048
  ChildIds: 9147458252479184642
  ChildIds: 14510015183247572985
  ChildIds: 15003889958795003277
  ChildIds: 11948394701769077224
  ChildIds: 15249968857746781203
  ChildIds: 3341597467137000654
  ChildIds: 14674904910307367959
  ChildIds: 6477806549589997352
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 16039953726478252130
    SubobjectId: 18446172874404528208
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6477806549589997352
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5749687279038267741
    SubobjectId: 7975411551228983663
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14674904910307367959
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17898941777036124386
    SubobjectId: 15636907095138719952
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3341597467137000654
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4906317735804578406
    SubobjectId: 7309933103163691604
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15249968857746781203
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 953943035089278442
    SubobjectId: 3195781895725002200
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 11948394701769077224
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13031074158491971707
    SubobjectId: 10786974838846900297
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15003889958795003277
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14406282736945663335
    SubobjectId: 16612021195404571989
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14510015183247572985
  Name: "Cone"
  Transform {
    Location {
      Y: 65
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2651206114834806263
    SubobjectId: 409367399825280453
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9147458252479184642
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5213136153137723242
    SubobjectId: 7583044882640490328
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 544320408982192048
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15514904617666239029
    SubobjectId: 17740988576192274951
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17679166974480841356
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 413571361577500664
    SubobjectId: 2655408985669994442
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6673665673209086385
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2685320253167037796
    SubobjectId: 297387228878509398
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15334481297929791313
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3374836465432272221
    SubobjectId: 1130816318946436463
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3981120372859470673
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10890371022283120310
    SubobjectId: 13134460445781976708
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17372308155002170148
  Name: "Cone"
  Transform {
    Location {
      Y: 40
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4937576382014088024
    SubobjectId: 7341271042254084970
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1789933635180683525
  Name: "Cone"
  Transform {
    Location {
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 251160903106939311
    SubobjectId: 2456969867346293149
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3418713158656861367
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11832668965829635799
    SubobjectId: 9606935750846453477
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17645112947854547505
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15768025467096558049
    SubobjectId: 18138215680971772371
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 13910519904598083903
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1117909601668406413
    SubobjectId: 3379731948834776255
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4397640758044087374
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14907308091323983593
    SubobjectId: 17259413537672421083
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 1621452080594853775
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5130523478632315426
    SubobjectId: 7374613031517045264
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 14674253902104820312
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -60
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18236131129488205493
    SubobjectId: 15886276392568102535
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9469719214498564796
  Name: "Cone"
  Transform {
    Location {
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8023231190675611630
    SubobjectId: 5637551065985034204
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17375679705368486414
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6309093081168452513
    SubobjectId: 8568874734887887763
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 2359653447951393509
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1437900877791379145
    SubobjectId: 3643649232258090747
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5197863348278240053
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14331467090370923444
    SubobjectId: 16683371455213663110
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9817696278949288064
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6108543538570702310
    SubobjectId: 8476130099516134868
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 5057665816307221324
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12142864829794916971
    SubobjectId: 9935147121154384473
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12979515632470679598
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -35
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4073510318343930452
    SubobjectId: 1868044538499775078
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15302688570313093088
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15149889112225258484
    SubobjectId: 17535771684762215366
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17020605518031085918
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11170987329567173254
    SubobjectId: 13430848285696447156
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 15250021899506479110
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13316887070653080979
    SubobjectId: 11073140565932547489
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 12721023197908404817
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7275099484420454678
    SubobjectId: 5013347505327718692
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 3294193931879272178
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16050620013197368198
    SubobjectId: 18436581621319852980
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17440352619188588579
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17413196766505442287
    SubobjectId: 15045610058864780253
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7072342247494432109
  Name: "Cone"
  Transform {
    Location {
      Y: 15
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11590326245730017764
    SubobjectId: 9348831669135317462
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 6819587533114199461
  Name: "Cone"
  Transform {
    Location {
      X: 75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18360760496388373085
    SubobjectId: 16116732653325288047
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 17241301015851726063
  Name: "Cone"
  Transform {
    Location {
      X: 50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5530768698460251950
    SubobjectId: 7900888534464519964
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16468113041274862262
  Name: "Cone"
  Transform {
    Location {
      X: 25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1345540252204961093
    SubobjectId: 3731501860193760631
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 4949124530701803776
  Name: "Cone"
  Transform {
    Location {
      X: -75
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1673346278232402281
    SubobjectId: 3917092646323474779
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 16217949309078767354
  Name: "Cone"
  Transform {
    Location {
      X: -50
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4059293893522299838
    SubobjectId: 1815274847357068172
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 579097832131304695
  Name: "Cone"
  Transform {
    Location {
      X: -25
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11271334980048747725
    SubobjectId: 13623239215232386303
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18397479859347564633
  Name: "Cone"
  Transform {
    Location {
      Y: -10
    }
    Rotation {
    }
    Scale {
      X: 0.2
      Y: 0.2
      Z: 1
    }
  }
  ParentId: 3109853297689081498
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 8377342645852709095
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4573044551307105675
    SubobjectId: 2166815653532954041
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 18147056077240695194
  Name: "Cube"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 0.25
    }
  }
  ParentId: 14614037832803765177
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 1528288499345411705
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceon"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 12095835209017042614
    }
    Teams {
    }
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 12759500020211041001
    SubobjectId: 10409645283022519003
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 7958916465235984201
  Name: "Trigger"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 1
    }
  }
  ParentId: 9949078653840365239
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 9734114137893278699
    SubobjectId: 11993685785562377177
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 9152915530480671407
  Name: "SpikeTrapServer"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 9949078653840365239
  UnregisteredParameters {
    Overrides {
      Name: "cs:Trigger"
      ObjectReference {
        SelfId: 7958916465235984201
      }
    }
    Overrides {
      Name: "cs:SpikeTrap"
      ObjectReference {
        SelfId: 9949078653840365239
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 4233072502576864937
    }
  }
  InstanceHistory {
    SelfId: 11304262192293148288
    SubobjectId: 13656156532816383666
    InstanceId: 2027877888927507601
    TemplateId: 13385094954737954345
  }
}
Objects {
  Id: 8348016030753923362
  Name: "Fantasy Castle Floor 01 4m"
  Transform {
    Location {
      X: -100
      Y: 100
      Z: 16.6666679
    }
    Rotation {
    }
    Scale {
      X: 0.5
      Y: 0.5
      Z: 0.5
    }
  }
  ParentId: 9949078653840365239
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10223008057381932438
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 5057709256497919050
  Name: "SpikeTrap"
  Transform {
    Location {
      X: 3900
      Y: 475
      Z: 425
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 3900
            Y: 25
            Z: 425
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1.5
            Y: 1.5
            Z: 1.5
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 4006365592851178976
  Name: "SpikeTrap"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4149476347164763570
      value {
        Overrides {
          Name: "Name"
          String: "SpikeTrap"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 3900
            Y: 375
            Z: 425
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1.5
            Y: 1.5
            Z: 1.5
          }
        }
      }
    }
    TemplateAsset {
      Id: 13385094954737954345
    }
  }
}
Objects {
  Id: 6803715026257547553
  Name: "FireTrapAutomatic"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 7452409739543324726
      value {
        Overrides {
          Name: "Position"
          Vector {
            X: 7.84842587
            Y: 171.52832
            Z: 92.0861816
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1
            Y: 9.24999809
            Z: 1
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 9678408652952434414
      value {
        Overrides {
          Name: "Position"
          Vector {
            X: 7.89607906
            Y: 172.073898
            Z: 92.0861816
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1
            Y: 9.99999905
            Z: 1
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 13457797889925135102
      value {
        Overrides {
          Name: "Name"
          String: "FireTrapAutomatic"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 3775
            Y: 100
            Z: 575
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
            Yaw: 5.00001621
          }
        }
      }
    }
    TemplateAsset {
      Id: 10047096576092887913
    }
  }
}
Objects {
  Id: 15961653796888257940
  Name: "Fantasy Castle Wall 02 - Door Basic Template"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 6614091521070465043
      value {
        Overrides {
          Name: "Name"
          String: "Fantasy Castle Wall 02 - Door Basic Template"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 4218.48682
            Y: -6597.47461
            Z: 408.101898
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
            Pitch: 6.83018879e-05
            Yaw: -0.000152587891
            Roll: 3.84464e-05
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1.17003584
            Y: 1.17003584
            Z: 1.17003584
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 17931694862368611225
      value {
        Overrides {
          Name: "Rotation"
          Rotator {
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1
            Y: 1
            Z: 1
          }
        }
      }
    }
    TemplateAsset {
      Id: 14423294838768630985
    }
  }
}
Objects {
  Id: 11223694863034159572
  Name: "Headlight"
  Transform {
    Location {
      X: -629.998596
      Y: 428.119934
      Z: -1.69408798
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 8723151346455698279
  Collidable_v2 {
    Value: "mc:ecollisionsetting:forceoff"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
  InstanceHistory {
    SelfId: 11223694863034159572
    SubobjectId: 12060261115952448602
    InstanceId: 6938452245308257429
    TemplateId: 8968402435106291397
    WasRoot: true
  }
}
Objects {
  Id: 8723151346455698279
  Name: "Headlight"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 11223694863034159572
  ChildIds: 9924640315396527615
  ChildIds: 8658432934481821927
  ChildIds: 3304214457833656256
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 8723151346455698279
    SubobjectId: 5013332650253618921
    InstanceId: 6938452245308257429
    TemplateId: 8968402435106291397
  }
}
Objects {
  Id: 3304214457833656256
  Name: "flashlight002"
  Transform {
    Location {
      X: 479.393127
      Y: -229.281174
      Z: 181.22229
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 8723151346455698279
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 2
    Color {
      R: 1
      G: 0.726868153
      B: 0.477918148
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      UseTemperature: true
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 1500
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 8658432934481821927
  Name: "flashlight001"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 8723151346455698279
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 51.4053764
    Color {
      R: 1
      G: 1
      B: 1
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      UseTemperature: true
      Temperature: 2721.44727
      LocalLight {
        AttenuationRadius: 2449.88354
        SpotLight {
          SourceRadius: 20
          SoftSourceRadius: 20
          FallOffExponent: 8
          UseFallOffExponent: true
          InnerConeAngle: 5.96733761
          OuterConeAngle: 26.9724865
          Profile {
            Value: "mc:espotlightprofile:basicspotlight"
          }
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
  InstanceHistory {
    SelfId: 8658432934481821927
    SubobjectId: 4950822083398423913
    InstanceId: 6938452245308257429
    TemplateId: 8968402435106291397
  }
}
Objects {
  Id: 9924640315396527615
  Name: "attachflashlight"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 8723151346455698279
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 8426941618525948718
    }
  }
  InstanceHistory {
    SelfId: 9924640315396527615
    SubobjectId: 13053493707258544241
    InstanceId: 6938452245308257429
    TemplateId: 8968402435106291397
  }
}
Objects {
  Id: 16800268766816622620
  Name: "SoulChestRed"
  Transform {
    Location {
      X: 4625
      Y: -5375
      Z: 423.496948
    }
    Rotation {
      Pitch: 7.51320767e-05
      Yaw: -89.9996948
      Roll: -6.10351563e-05
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 8061669763193369063
  ChildIds: 11256872589810691428
  ChildIds: 2468606055639013243
  ChildIds: 6884625145148782081
  ChildIds: 1373605207614956242
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 1373605207614956242
  Name: "MessageTriggerInteractable"
  Transform {
    Location {
      X: 304.669983
      Y: 15.0979614
      Z: -7.16661406
    }
    Rotation {
      Pitch: -6.14717e-05
      Yaw: 89.9996796
      Roll: -7.51317421e-05
    }
    Scale {
      X: 0.34685427
      Y: 0.34685427
      Z: 0.34685427
    }
  }
  ParentId: 16800268766816622620
  UnregisteredParameters {
    Overrides {
      Name: "cs:message"
      String: "You have recovered the red fragment of your soul"
    }
    Overrides {
      Name: "cs:duration"
      Float: 2
    }
    Overrides {
      Name: "cs:OneTimeOnly"
      Bool: true
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsFilePartition: true
    FilePartitionName: "MessageTriggerInteractable"
  }
  InstanceHistory {
    SelfId: 1373605207614956242
    SubobjectId: 2814553959838237322
    InstanceId: 10148826954738912066
    TemplateId: 872686746320534654
  }
}
Objects {
  Id: 6884625145148782081
  Name: "Magic Bright Light Reveal 01 SFX"
  Transform {
    Location {
    }
    Rotation {
      Yaw: -1.24964531e-24
      Roll: 1.95413269e-11
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 16800268766816622620
  WantsNetworking: true
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  AudioInstance {
    AudioAsset {
      Id: 5903341814524998140
    }
    Volume: 1
    Falloff: -1
    Radius: -1
    EnableOcclusion: true
    IsSpatializationEnabled: true
    IsAttenuationEnabled: true
  }
}
Objects {
  Id: 2468606055639013243
  Name: "RedHeartTrigger"
  Transform {
    Location {
      Y: 0.725097656
    }
    Rotation {
    }
    Scale {
      X: 1.72555661
      Y: 1.42097592
      Z: 2.46269035
    }
  }
  ParentId: 16800268766816622620
  ChildIds: 1483813581580370415
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    Interactable: true
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
}
Objects {
  Id: 1483813581580370415
  Name: "RedHeartAbility"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 0.579523146
      Y: 0.70374167
      Z: 0.40605998
    }
  }
  ParentId: 2468606055639013243
  UnregisteredParameters {
    Overrides {
      Name: "cs:soundEffect"
      ObjectReference {
        SelfId: 6884625145148782081
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 13932722400797916416
    }
  }
}
Objects {
  Id: 11256872589810691428
  Name: "Heart - Polished"
  Transform {
    Location {
      X: -11.6611328
      Y: 1.31396484
      Z: 58.5211182
    }
    Rotation {
      Yaw: -90.4749756
    }
    Scale {
      X: 0.441308677
      Y: 0.441308677
      Z: 0.441308677
    }
  }
  ParentId: 16800268766816622620
  ChildIds: 17358890102547336140
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:color"
      Color {
        R: 0.0195366722
        B: 0.590000033
        A: 1
      }
    }
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 7521953718214011541
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10699037443616032253
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 17358890102547336140
  Name: "Point Light"
  Transform {
    Location {
      X: 8.76338196
      Y: 12.2693491
      Z: -5.58502865
    }
    Rotation {
      Yaw: -79.5247803
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 11256872589810691428
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 7.68552065
    Color {
      R: 0.580000043
      G: 2.76565572e-07
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 4238.39502
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 8061669763193369063
  Name: "Chest Small Opened"
  Transform {
    Location {
    }
    Rotation {
      Yaw: 89.4305344
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 16800268766816622620
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 7998966226707493060
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 13231938497781083742
  Name: "SoulChestWhite"
  Transform {
    Location {
      X: 8753.27441
      Y: 479.400269
      Z: 423.496948
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 1768227212068037207
  ChildIds: 11582633733973479919
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 11582633733973479919
  Name: "Heart - Polished"
  Transform {
    Location {
      X: -11.6611328
      Y: 1.31394958
      Z: 58.5211182
    }
    Rotation {
      Yaw: -90.4749756
    }
    Scale {
      X: 0.441308677
      Y: 0.441308677
      Z: 0.441308677
    }
  }
  ParentId: 13231938497781083742
  ChildIds: 1187647913596172569
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:color"
      Color {
        R: 0.0195366722
        B: 0.590000033
        A: 1
      }
    }
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 7521953718214011541
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10699037443616032253
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 1187647913596172569
  Name: "Point Light"
  Transform {
    Location {
      X: 8.76318645
      Y: 12.2688694
      Z: -5.58502197
    }
    Rotation {
      Yaw: -79.5247803
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 11582633733973479919
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 7.68552065
    Color {
      R: 0.99
      G: 1
      B: 1
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 4238.39502
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 1768227212068037207
  Name: "Chest Small Opened"
  Transform {
    Location {
    }
    Rotation {
      Yaw: 89.4305344
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 13231938497781083742
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 7998966226707493060
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 8096458904255746710
  Name: "SoulChestBlue"
  Transform {
    Location {
      X: 8753.27441
      Y: 1.45036316
      Z: 423.496948
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 7981743316756937936
  ChildIds: 9085650004128617067
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 9085650004128617067
  Name: "Heart - Polished"
  Transform {
    Location {
      X: -11.6611328
      Y: 23.8885422
      Z: 58.5211182
    }
    Rotation {
      Yaw: -90.4749756
    }
    Scale {
      X: 0.441308677
      Y: 0.441308677
      Z: 0.441308677
    }
  }
  ParentId: 8096458904255746710
  ChildIds: 14143554083780515960
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:color"
      Color {
        R: 0.0195366722
        B: 0.590000033
        A: 1
      }
    }
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 7521953718214011541
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10699037443616032253
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 14143554083780515960
  Name: "Point Light"
  Transform {
    Location {
      X: 8.76318645
      Y: 12.2688694
      Z: -5.58502197
    }
    Rotation {
      Yaw: -79.5247803
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 9085650004128617067
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 7.68552065
    Color {
      G: 0.0243705548
      B: 0.919999957
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 4238.39502
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 7981743316756937936
  Name: "Chest Small Opened"
  Transform {
    Location {
      Y: 23.145813
    }
    Rotation {
      Yaw: 89.4305344
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 8096458904255746710
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 7998966226707493060
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 18320808188208391474
  Name: "SoulChestYellow"
  Transform {
    Location {
      X: 8753.27441
      Y: 325.856934
      Z: 423.496948
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 12515180038881034276
  ChildIds: 16734735863019858611
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 16734735863019858611
  Name: "Heart - Polished"
  Transform {
    Location {
      X: -11.6611328
      Y: 1.31394958
      Z: 58.5211182
    }
    Rotation {
      Yaw: -90.4749756
    }
    Scale {
      X: 0.441308677
      Y: 0.441308677
      Z: 0.441308677
    }
  }
  ParentId: 18320808188208391474
  ChildIds: 2900732787693574015
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:color"
      Color {
        R: 0.0195366722
        B: 0.590000033
        A: 1
      }
    }
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 7521953718214011541
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10699037443616032253
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 2900732787693574015
  Name: "Point Light"
  Transform {
    Location {
      X: 8.76318645
      Y: 12.2688694
      Z: -5.58502197
    }
    Rotation {
      Yaw: -79.5247803
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 16734735863019858611
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 7.68552065
    Color {
      R: 0.87
      G: 0.812384188
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 4238.39502
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 12515180038881034276
  Name: "Chest Small Opened"
  Transform {
    Location {
    }
    Rotation {
      Yaw: 89.4305344
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 18320808188208391474
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 7998966226707493060
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 6862748695550464527
  Name: "SoulChestGreen"
  Transform {
    Location {
      X: 8753.27441
      Y: 177.946213
      Z: 423.496948
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 7082261159821201200
  ChildIds: 1320884810538339505
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 1320884810538339505
  Name: "Heart - Polished"
  Transform {
    Location {
      X: -11.6611328
      Y: 1.31394958
      Z: 58.5211182
    }
    Rotation {
      Yaw: -90.4749756
    }
    Scale {
      X: 0.441308677
      Y: 0.441308677
      Z: 0.441308677
    }
  }
  ParentId: 6862748695550464527
  ChildIds: 1723411626961945680
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:color"
      Color {
        R: 0.0195366722
        B: 0.590000033
        A: 1
      }
    }
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 7521953718214011541
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 10699037443616032253
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 1723411626961945680
  Name: "Point Light"
  Transform {
    Location {
      X: 8.76318645
      Y: 12.2688694
      Z: -5.58502197
    }
    Rotation {
      Yaw: -79.5247803
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 1320884810538339505
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Light {
    Intensity: 7.68552065
    Color {
      G: 0.86
      B: 0.0227815825
      A: 1
    }
    VolumetricIntensity: 5
    TeamSettings {
    }
    Light {
      Temperature: 2000
      LocalLight {
        AttenuationRadius: 4238.39502
        PointLight {
          SourceRadius: 55.3788338
          SoftSourceRadius: 255.219727
          FallOffExponent: 8
        }
      }
      MaxDrawDistance: 5000
      MaxDistanceFadeRange: 1000
    }
  }
}
Objects {
  Id: 7082261159821201200
  Name: "Chest Small Opened"
  Transform {
    Location {
    }
    Rotation {
      Yaw: 89.4305344
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 6862748695550464527
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 7998966226707493060
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
}
Objects {
  Id: 9131728340401120455
  Name: "Fantasy Candle Lit - Sconce 02 (Prop)"
  Transform {
    Location {
      X: -50
      Y: -200
      Z: 400
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 9287064100231657554
      value {
        Overrides {
          Name: "CastShadows"
          Bool: true
        }
        Overrides {
          Name: "AttenuationRadius"
          Float: 1500
        }
        Overrides {
          Name: "Intensity"
          Float: 2
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 0.234558105
            Z: 7.21635056
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 16344326152152828370
      value {
        Overrides {
          Name: "Name"
          String: "Fantasy Candle Lit - Sconce 02 (Prop)"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: -50
            Y: 578.823914
            Z: 400
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
            Yaw: -169.999756
          }
        }
      }
    }
    TemplateAsset {
      Id: 11734022475402826407
    }
  }
}
Objects {
  Id: 8206587631497182582
  Name: "Fantasy Candle Lit - Sconce 02 (Prop)"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 9287064100231657554
      value {
        Overrides {
          Name: "CastShadows"
          Bool: true
        }
        Overrides {
          Name: "AttenuationRadius"
          Float: 1500
        }
        Overrides {
          Name: "Intensity"
          Float: 2
        }
      }
    }
    ParameterOverrideMap {
      key: 16344326152152828370
      value {
        Overrides {
          Name: "Name"
          String: "Fantasy Candle Lit - Sconce 02 (Prop)"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: -50
            Y: -180.565125
            Z: 400
          }
        }
        Overrides {
          Name: "Rotation"
          Rotator {
          }
        }
      }
    }
    TemplateAsset {
      Id: 11734022475402826407
    }
  }
}
Objects {
  Id: 10914247158698788748
  Name: "ArrowTrapAutomatic"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  WantsNetworking: true
  TemplateInstance {
    ParameterOverrideMap {
      key: 2303106816200482418
      value {
        Overrides {
          Name: "Name"
          String: "ArrowTrapAutomatic"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: 4100
            Y: 100
            Z: 550
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 10712076960726413682
      value {
        Overrides {
          Name: "Position"
          Vector {
            Y: -390.312317
            Z: 140.23349
          }
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 0.635209739
            Y: 2.91840839
            Z: 3.51904464
          }
        }
      }
    }
    TemplateAsset {
      Id: 17405356203648486993
    }
  }
}
Objects {
  Id: 5666405351775097228
  Name: "Spike Trap"
  Transform {
    Location {
      X: 1791.98462
      Y: 201.37738
      Z: -1763.12915
    }
    Rotation {
    }
    Scale {
      X: 0.903129637
      Y: 0.903129637
      Z: 0.903129637
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 8012537689750227960
  ChildIds: 6084462805433624330
  ChildIds: 10671629295704699078
  ChildIds: 17473604252931172644
  ChildIds: 949245371107637428
  ChildIds: 16630434257629797157
  ChildIds: 1568687787058717019
  ChildIds: 16893701500506734907
  ChildIds: 9578656287164039399
  ChildIds: 10349569859894189877
  ChildIds: 5900945066314498621
  ChildIds: 6837933563372996751
  ChildIds: 7104058016240909652
  ChildIds: 15825916378012146850
  ChildIds: 16166807889384796208
  ChildIds: 11472658203266784999
  ChildIds: 13461763842924099515
  ChildIds: 4560842004393393555
  ChildIds: 17361572052367796242
  ChildIds: 9946966333578886843
  ChildIds: 280475136093855860
  ChildIds: 11203327091716198952
  ChildIds: 6975040402609670524
  ChildIds: 4595692436192642413
  ChildIds: 14766280314600195857
  ChildIds: 14237396848520652158
  ChildIds: 18335525949239832180
  ChildIds: 3225754803809578237
  ChildIds: 5780301478576078470
  ChildIds: 2923402450222143849
  ChildIds: 11220924729532649228
  ChildIds: 7543523032962642412
  ChildIds: 8562741776022826921
  ChildIds: 5791112080589376976
  ChildIds: 2460666956184818319
  ChildIds: 8247367712360736246
  ChildIds: 3385252867893406948
  ChildIds: 11132766501303927010
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
  InstanceHistory {
    SelfId: 5666405351775097228
    SubobjectId: 8101139538256772281
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
    WasRoot: true
  }
}
Objects {
  Id: 11132766501303927010
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -76.2995605
      Y: 126.662598
      Z: 6.59068298
    }
    Rotation {
      Pitch: 5.15249634
      Yaw: 66.9214172
      Roll: -8.42466354
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11132766501303927010
    SubobjectId: 11867428114358414807
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 3385252867893406948
  Name: "KillZoneServer"
  Transform {
    Location {
      Z: -0.000122070313
    }
    Rotation {
    }
    Scale {
      X: 2
      Y: 2
      Z: 2
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "cs:KillTrigger"
      ObjectReference {
        SelfId: 8247367712360736246
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 3908110495107565482
    }
  }
  InstanceHistory {
    SelfId: 3385252867893406948
    SubobjectId: 16145483188601114806
    InstanceId: 14858778503191106278
    TemplateId: 7064774221429051261
  }
}
Objects {
  Id: 8247367712360736246
  Name: "KillTrigger"
  Transform {
    Location {
      Z: 100
    }
    Rotation {
    }
    Scale {
      X: 7.5
      Y: 7.5
      Z: 3.75000024
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Trigger {
    TeamSettings {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    TriggerShape_v2 {
      Value: "mc:etriggershape:box"
    }
  }
  InstanceHistory {
    SelfId: 8247367712360736246
    SubobjectId: 13591331349196528036
    InstanceId: 14858778503191106278
    TemplateId: 7064774221429051261
  }
}
Objects {
  Id: 2460666956184818319
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 20.0742188
      Y: 87.0385742
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 68.4481735
      Roll: 5.17006159
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2460666956184818319
    SubobjectId: 2082933895127891898
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 5791112080589376976
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -221.694824
      Y: 322.641113
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: -55.1160812
      Roll: 4.27279161e-07
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5791112080589376976
    SubobjectId: 7966923925269979365
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 8562741776022826921
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -81.2028809
      Y: 236.8125
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: -43.308651
      Roll: 0.386968106
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8562741776022826921
    SubobjectId: 5195714294321971868
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 7543523032962642412
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 18.972168
      Y: 297.428223
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 177.029968
      Roll: 5.16943312
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7543523032962642412
    SubobjectId: 6224503427359104217
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 11220924729532649228
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 156.052612
      Y: 233.117676
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: 177.655151
      Roll: 0.386963964
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11220924729532649228
    SubobjectId: 11922894426054550073
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 2923402450222143849
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 241.311768
      Y: 299.588867
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 141.50824
      Roll: 5.16956615
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 2923402450222143849
    SubobjectId: 1611191158048339036
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 5780301478576078470
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 315.518799
      Y: 167.603516
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: 142.133163
      Roll: 0.386960804
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5780301478576078470
    SubobjectId: 7996663722124170163
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 3225754803809578237
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 350.82373
      Y: 290.12793
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: 141.529373
      Roll: 1.976166e-06
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 3225754803809578237
    SubobjectId: 1299908889681297864
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 18335525949239832180
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -239.011475
      Y: 247.004883
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: -81.6360321
      Roll: 0.386961639
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 18335525949239832180
    SubobjectId: 13887629469572809537
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 14237396848520652158
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -276.726074
      Y: 100.360352
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: -82.261322
      Roll: 5.1690774
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14237396848520652158
    SubobjectId: 18112210894071072843
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 14766280314600195857
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -221.694824
      Y: -26.8095703
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: -46.7224
      Roll: 6.94328605e-07
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 14766280314600195857
    SubobjectId: 17447586445262940708
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 4595692436192642413
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -169.172852
      Y: 89.3842773
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: -46.1180191
      Roll: 0.386969209
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4595692436192642413
    SubobjectId: 74651563971422296
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 6975040402609670524
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -349.262207
      Y: 182.949707
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: -82.2403412
      Roll: 2.24321548e-06
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6975040402609670524
    SubobjectId: 6774056582357181513
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 11203327091716198952
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -281.26
      Y: -291.237793
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 11.1862736
      Roll: 5.17024088
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11203327091716198952
    SubobjectId: 11940217412685070109
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 280475136093855860
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -169.351074
      Y: -330.973145
      Z: 6.59068298
    }
    Rotation {
      Yaw: 26.8993454
      Roll: -7.50763702
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 280475136093855860
    SubobjectId: 4407450076573846849
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 9946966333578886843
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -182.625
      Y: -81.5029297
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: 150.245636
      Roll: 2.4568551e-06
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 9946966333578886843
    SubobjectId: 13025716297575093134
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 17361572052367796242
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -198.953613
      Y: -207.964355
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: 150.849915
      Roll: 0.386969537
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17361572052367796242
    SubobjectId: 14861503920877634855
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 4560842004393393555
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -292.305908
      Y: -88.7446289
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 150.224838
      Roll: 5.1695509
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 4560842004393393555
    SubobjectId: 109572360499859622
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 13461763842924099515
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -350.767578
      Y: 14.6206055
      Z: 6.59068298
    }
    Rotation {
      Yaw: 165.935928
      Roll: -7.50721073
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 13461763842924099515
    SubobjectId: 9520557093534816910
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 11472658203266784999
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -87.277832
      Y: 34.1494141
      Z: 6.59068298
    }
    Rotation {
      Yaw: -158.864136
      Roll: -7.50708771
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 11472658203266784999
    SubobjectId: 11671372011039880146
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 16166807889384796208
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 20.0742188
      Y: -16.6220703
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: -174.576477
      Roll: 5.16937494
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16166807889384796208
    SubobjectId: 16037899669678103813
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 15825916378012146850
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 105.527344
      Y: 52.5136719
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: -174.555603
      Roll: 1.89605123e-06
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 15825916378012146850
    SubobjectId: 16532408296996647319
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 7104058016240909652
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 165.074341
      Y: -60.2334
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: -173.951309
      Roll: 0.386964113
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 7104058016240909652
    SubobjectId: 6654268527228866657
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 6837933563372996751
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 349.437622
      Y: 24.5976563
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: 149.923141
      Roll: 2.40344525e-06
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6837933563372996751
    SubobjectId: 6929670387321431482
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 5900945066314498621
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 239.717407
      Y: 17.9711914
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: 149.901901
      Roll: 5.16950798
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 5900945066314498621
    SubobjectId: 8010290331293773576
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 10349569859894189877
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 181.837036
      Y: 121.665039
      Z: 6.59068298
    }
    Rotation {
      Yaw: 165.613617
      Roll: -7.50739431
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10349569859894189877
    SubobjectId: 12785460047435198976
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 9578656287164039399
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 332.395752
      Y: -101.768555
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: 150.526901
      Roll: 0.386960685
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 9578656287164039399
    SubobjectId: 13411759259469639122
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 16893701500506734907
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -99.1259766
      Y: -215.391602
    }
    Rotation {
      Pitch: 2.45548701
      Yaw: -35.5195618
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16893701500506734907
    SubobjectId: 15329240319417379854
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 1568687787058717019
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 10.7280273
      Y: -219.20166
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: -35.5405579
      Roll: 5.16871452
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 1568687787058717019
    SubobjectId: 3101577043534875758
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 16630434257629797157
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 58.512207
      Y: -327.914551
      Z: 6.59068298
    }
    Rotation {
      Yaw: -19.8269615
      Roll: -7.50696468
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 16630434257629797157
    SubobjectId: 15565901564064642576
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 949245371107637428
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: -70.1794434
      Y: -91.2114258
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: -34.9151726
      Roll: 0.386968642
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 949245371107637428
    SubobjectId: 3738690806824441217
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 17473604252931172644
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 92.4506836
      Y: -148.424805
      Z: 1.99362183
    }
    Rotation {
      Pitch: -7.49749136
      Yaw: 0.60445118
      Roll: 0.386970311
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 17473604252931172644
    SubobjectId: 14749478606152418321
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 10671629295704699078
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 141.037109
      Y: -266.314941
    }
    Rotation {
      Pitch: 2.45548701
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.92495346
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 10671629295704699078
    SubobjectId: 12310348331047362035
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 6084462805433624330
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 232.662354
      Y: -205.591309
      Z: 6.59068298
    }
    Rotation {
      Pitch: -0.232602075
      Yaw: -0.0209960882
      Roll: 5.16856146
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.35750389
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 6084462805433624330
    SubobjectId: 7691656093486107199
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 8012537689750227960
  Name: "Fantasy Sword Blade 04"
  Transform {
    Location {
      X: 334.714966
      Y: -266.314941
      Z: 6.59068298
    }
    Rotation {
      Yaw: 15.6928043
      Roll: -7.50690365
    }
    Scale {
      X: 2.56143451
      Y: 11.1994257
      Z: 2.56143451
    }
  }
  ParentId: 5666405351775097228
  UnregisteredParameters {
    Overrides {
      Name: "ma:Shared_BaseMaterial:id"
      AssetReference {
        Id: 14364313178059886990
      }
    }
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  CoreMesh {
    MeshAsset {
      Id: 13888119501670323283
    }
    Teams {
      IsTeamCollisionEnabled: true
      IsEnemyCollisionEnabled: true
    }
    EnableCameraCollision: true
    StaticMesh {
      Physics {
      }
    }
  }
  InstanceHistory {
    SelfId: 8012537689750227960
    SubobjectId: 5907696093109036749
    InstanceId: 4920161930868300504
    TemplateId: 14560239590594625565
  }
}
Objects {
  Id: 11504432768120143721
  Name: "Sky Nighttime 01"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  TemplateInstance {
    ParameterOverrideMap {
      key: 4586248533900355589
      value {
        Overrides {
          Name: "bp:Star Brightness "
          Float: 0.5
        }
        Overrides {
          Name: "bp:Star Visibility"
          Float: 0
        }
      }
    }
    ParameterOverrideMap {
      key: 5637922765994959926
      value {
        Overrides {
          Name: "bp:Brightness"
          Float: 1
        }
      }
    }
    ParameterOverrideMap {
      key: 8768135237325925539
      value {
        Overrides {
          Name: "bp:Fog Density"
          Float: 10
        }
        Overrides {
          Name: "bp:Opacity"
          Float: 1
        }
        Overrides {
          Name: "bp:Volumetric Fog"
          Bool: false
        }
        Overrides {
          Name: "bp:color"
          Color {
            R: 0.0990000069
            A: 1
          }
        }
        Overrides {
          Name: "bp:Start"
          Float: 0
        }
        Overrides {
          Name: "bp:Falloff"
          Float: 0.500835478
        }
      }
    }
    ParameterOverrideMap {
      key: 13664821734768608629
      value {
        Overrides {
          Name: "Name"
          String: "Sky Nighttime 01"
        }
        Overrides {
          Name: "Position"
          Vector {
            X: -150
          }
        }
      }
    }
    ParameterOverrideMap {
      key: 14977169413056414029
      value {
        Overrides {
          Name: "bp:Intensity"
          Float: 0
        }
      }
    }
    ParameterOverrideMap {
      key: 16180970171577782523
      value {
        Overrides {
          Name: "bp:Intensity"
          Float: 0.5
        }
        Overrides {
          Name: "bp:Cast Shadows"
          Bool: true
        }
        Overrides {
          Name: "Rotation"
          Rotator {
            Pitch: -36.9108887
            Yaw: 4.26431608
            Roll: 5.98035
          }
        }
      }
    }
    TemplateAsset {
      Id: 9904014693973804548
    }
  }
}
Objects {
  Id: 6826436379014069217
  Name: "Path"
  Transform {
    Location {
      X: 200
      Y: -200
      Z: -50
    }
    Rotation {
      Yaw: 89.9998245
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsFilePartition: true
    FilePartitionName: "Path"
  }
}
Objects {
  Id: 14713340454944924967
  Name: "Third Person Camera Settings"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  ChildIds: 4226120016796708080
  ChildIds: 2434826500834513063
  ChildIds: 724324913679364851
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Folder {
    IsGroup: true
  }
}
Objects {
  Id: 724324913679364851
  Name: "Client Context"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14713340454944924967
  ChildIds: 3567959178173361743
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  NetworkContext {
  }
}
Objects {
  Id: 3567959178173361743
  Name: "Third Person Camera"
  Transform {
    Location {
      X: -150
      Z: 500
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 724324913679364851
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Camera {
    UseAsDefault: true
    AttachToLocalPlayer: true
    InitialDistance: 400
    MinDistance: 300
    MaxDistance: 600
    PositionOffset {
      Y: 60
    }
    RotationOffset {
    }
    FieldOfView: 90
    ViewWidth: 1200
    RotationMode {
      Value: "mc:erotationmode:lookangle"
    }
    MinPitch: -89
    MaxPitch: 89
    DoesPositionOffsetSpring: true
  }
}
Objects {
  Id: 2434826500834513063
  Name: "Resource Display"
  Transform {
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14713340454944924967
  TemplateInstance {
    ParameterOverrideMap {
      key: 12815525979607197974
      value {
        Overrides {
          Name: "Name"
          String: "Resource Display"
        }
        Overrides {
          Name: "Scale"
          Vector {
            X: 1
            Y: 1
            Z: 1
          }
        }
        Overrides {
          Name: "cs:ShowProgressBar"
          Bool: true
        }
        Overrides {
          Name: "cs:ShowMaxInText"
          Bool: true
        }
        Overrides {
          Name: "cs:AlwaysShow"
          Bool: true
        }
        Overrides {
          Name: "cs:ResourceName"
          String: "hearts"
        }
      }
    }
    ParameterOverrideMap {
      key: 13513497818209532703
      value {
        Overrides {
          Name: "Label"
          String: "Integrity"
        }
      }
    }
    ParameterOverrideMap {
      key: 14059023812613610750
      value {
        Overrides {
          Name: "Image"
          AssetReference {
            Id: 9664173434616826316
          }
        }
        Overrides {
          Name: "Color"
          Color {
            R: 0.350000024
            G: 0.457615733
            B: 1
            A: 1
          }
        }
      }
    }
    TemplateAsset {
      Id: 6970408180922598042
    }
  }
}
Objects {
  Id: 4226120016796708080
  Name: "Third Person Player Settings"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 14713340454944924967
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Settings {
    IsDefault: true
    PlayerMovementSettings {
      WalkSpeed: 640
      MaxAcceleration: 1800
      WalkableFloorAngle: 44
      JumpMaxCount: 1
      JumpVelocity: 900
      GroundFriction: 8
      GravityScale: 1.9
      MaxSwimSpeed: 420
      Buoyancy: 1
      TouchForceFactor: 1
      BrakingDecelerationFlying: 600
      MaxFlightSpeed: 600
      MovementControlMode {
        Value: "mc:emovementcontrolmode:lookrelative"
      }
      LookControlMode {
        Value: "mc:elookcontrolmode:relative"
      }
      FacingMode {
        Value: "mc:efacingmode:faceaimwhenactive"
      }
      DefaultRotationRate: 540
      SlideRotationRate: 20
      LookAtCursorProjectionPlane {
        Value: "mc:eprojectionplane:xy"
      }
      MountedMaxAcceleration: 1800
      MountedWalkSpeed: 960
      MountedJumpMaxCount: 1
      MountedJumpVelocity: 900
      HeadVisibleToSelf: true
      IsSlideEnabled: true
      IsJumpEnabled: true
      CanMoveForward: true
      CanMoveBackward: true
      CanMoveLeft: true
      CanMoveRight: true
      AbilityAimMode {
        Value: "mc:eabilityaimmode:viewrelative"
      }
      AppearanceChannelingTime: 2
      MountChannelingTime: 2
    }
  }
}
Objects {
  Id: 11471710598079691502
  Name: "Respawn Settings"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Settings {
    IsDefault: true
    RespawnSettings {
      RespawnDelay: 5
      RespawnMode_v2 {
        Value: "mc:erespawnmode:atclosestspawnpoint"
      }
    }
  }
}
Objects {
  Id: 16813558807825262224
  Name: "Spawn Point"
  Transform {
    Location {
      X: -150
      Y: 200
      Z: 115
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  UnregisteredParameters {
  }
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  PlayerSpawnPoint {
    TeamInt: 1
    PlayerScaleMultiplier: 1
  }
}
Objects {
  Id: 7367735074338159388
  Name: "Game Settings"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Settings {
    IsDefault: true
    GameSettings {
      RagdollOnDeath: true
      ChatMode {
        Value: "mc:echatmode:teamandall"
      }
    }
  }
}
Objects {
  Id: 9702398848862610955
  Name: "PlayerSettingStart"
  Transform {
    Location {
    }
    Rotation {
    }
    Scale {
      X: 1
      Y: 1
      Z: 1
    }
  }
  ParentId: 4781671109827199097
  Collidable_v2 {
    Value: "mc:ecollisionsetting:inheritfromparent"
  }
  Visible_v2 {
    Value: "mc:evisibilitysetting:inheritfromparent"
  }
  Script {
    ScriptAsset {
      Id: 6356467144447137395
    }
  }
}
