Assets {
  Id: 16654604852275850857
  Name: "FireTrap"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 16438529600030497322
      Objects {
        Id: 16438529600030497322
        Name: "FireTrap"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 15758204339171781267
        ChildIds: 12896932666644856028
        ChildIds: 6666178998657084514
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
        Id: 15758204339171781267
        Name: "FireSwitch"
        Transform {
          Location {
            X: -1120.52014
            Y: -171.144501
            Z: 10
          }
          Rotation {
            Yaw: -4.99978638
          }
          Scale {
            X: 0.232694715
            Y: 0.232694715
            Z: 0.232694715
          }
        }
        ParentId: 16438529600030497322
        ChildIds: 9103851455233197730
        ChildIds: 3395765018904652877
        ChildIds: 15196453088181788073
        ChildIds: 17301987653144469119
        UnregisteredParameters {
          Overrides {
            Name: "ma:Building_WallInner:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 15980367545100223132
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
        Id: 9103851455233197730
        Name: "Geo"
        Transform {
          Location {
            X: 108.730865
            Y: -20.8070164
            Z: -26.4081421
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 15758204339171781267
        WantsNetworking: true
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
        Id: 3395765018904652877
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            X: 108.73085
            Y: -23.273016
            Z: -26.4081421
          }
          Rotation {
            Yaw: 179.999756
          }
          Scale {
            X: 2.70746183
            Y: 0.630932093
            Z: 4.0123024
          }
        }
        ParentId: 15758204339171781267
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
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
        Id: 15196453088181788073
        Name: "Cube - bottom aligned"
        Transform {
          Location {
            X: 108.730873
            Y: -18.3410435
            Z: 157.047134
          }
          Rotation {
            Pitch: -0.000183105469
            Yaw: -0.000457763672
            Roll: 136.444382
          }
          Scale {
            X: 0.766999066
            Y: 0.51534754
            Z: 1.61468697
          }
        }
        ParentId: 15758204339171781267
        ChildIds: 13561333888009855941
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CoreMesh {
          MeshAsset {
            Id: 17609149353171719671
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
        Id: 13561333888009855941
        Name: "FireSwitch"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
          }
        }
        ParentId: 15196453088181788073
        UnregisteredParameters {
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SubObjectId: 17301987653144469119
            }
          }
          Overrides {
            Name: "cs:FirePosition"
            ObjectReference {
              SubObjectId: 7626391218643123995
            }
          }
          Overrides {
            Name: "cs:FireBlast"
            AssetReference {
              Id: 5126412108218167896
            }
          }
          Overrides {
            Name: "cs:TriggerTop"
            ObjectReference {
              SubObjectId: 9035208620492006363
            }
          }
          Overrides {
            Name: "cs:FirePositionTop"
            ObjectReference {
              SubObjectId: 1971586113231562354
            }
          }
          Overrides {
            Name: "cs:Dir"
            Bool: false
          }
          Overrides {
            Name: "cs:FireBlast2"
            AssetReference {
              Id: 3537381627319651267
            }
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 6090699806219449498
          }
        }
      }
      Objects {
        Id: 17301987653144469119
        Name: "Trigger"
        Transform {
          Location {
            X: 145.374268
            Y: 242.522736
            Z: -227.392731
          }
          Rotation {
            Yaw: 179.999756
          }
          Scale {
            X: 4.29747629
            Y: 4.29747629
            Z: 4.29747629
          }
        }
        ParentId: 15758204339171781267
        WantsNetworking: true
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
        Id: 12896932666644856028
        Name: "FireTrap"
        Transform {
          Location {
            X: -516.112061
            Y: -129.695679
            Z: -54.949707
          }
          Rotation {
            Yaw: -4.12698364
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 16438529600030497322
        ChildIds: 10051937027319559690
        ChildIds: 7626391218643123995
        ChildIds: 7890040085995121361
        ChildIds: 16815571361175000652
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
        Id: 10051937027319559690
        Name: "ClientContext"
        Transform {
          Location {
            X: 7.65257359
            Y: -117.202042
            Z: 12.3380127
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 12896932666644856028
        ChildIds: 6508346686459923876
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
        Id: 6508346686459923876
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
        ParentId: 10051937027319559690
        ChildIds: 7925982369464170711
        ChildIds: 5211363334509404507
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
        Id: 7925982369464170711
        Name: "Base"
        Transform {
          Location {
            Y: 16.1610794
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 0.186761215
            Z: 1.22203422
          }
        }
        ParentId: 6508346686459923876
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
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
            Id: 17609149353171719671
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
        Id: 5211363334509404507
        Name: "Skull"
        Transform {
          Location {
            Y: -16.1610794
            Z: 32.0962639
          }
          Rotation {
          }
          Scale {
            X: 3.98808932
            Y: 3.98808932
            Z: 3.98808932
          }
        }
        ParentId: 6508346686459923876
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
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
            Id: 13417453355201377219
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
        Id: 7626391218643123995
        Name: "Position"
        Transform {
          Location {
            X: -22.7464752
            Y: -61.9633293
            Z: 32.8110352
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 12896932666644856028
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsFilePartition: true
          FilePartitionName: "Position"
        }
      }
      Objects {
        Id: 7890040085995121361
        Name: "StartFire"
        Transform {
          Location {
            X: -33.9721146
            Y: -31.5106678
            Z: 67.442627
          }
          Rotation {
          }
          Scale {
          }
        }
        ParentId: 12896932666644856028
        UnregisteredParameters {
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
          }
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SubObjectId: 16815571361175000652
            }
          }
          Overrides {
            Name: "cs:FireSwitch"
            ObjectReference {
              SubObjectId: 13561333888009855941
            }
          }
          Overrides {
            Name: "cs:Dir"
            Bool: true
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
            Id: 15288972945499590744
          }
        }
      }
      Objects {
        Id: 16815571361175000652
        Name: "Trigger"
        Transform {
          Location {
            X: 7.84841347
            Y: 171.528336
            Z: 92.0861816
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 4.96348906
            Z: 1
          }
        }
        ParentId: 12896932666644856028
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
      }
      Objects {
        Id: 6666178998657084514
        Name: "FireTrapTop"
        Transform {
          Location {
            X: -516.112061
            Y: -129.695679
            Z: 139.958618
          }
          Rotation {
            Yaw: -4.12698364
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 16438529600030497322
        ChildIds: 10354219509693047205
        ChildIds: 1971586113231562354
        ChildIds: 6111999193183961262
        ChildIds: 9035208620492006363
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
        Id: 10354219509693047205
        Name: "ClientContext"
        Transform {
          Location {
            X: 7.65254593
            Y: -117.20208
            Z: 12.3380241
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 6666178998657084514
        ChildIds: 2591419040371737519
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
        Id: 2591419040371737519
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
        ParentId: 10354219509693047205
        ChildIds: 16116562180163186725
        ChildIds: 10959909560365819718
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
        Id: 16116562180163186725
        Name: "Base"
        Transform {
          Location {
            Y: 16.1610794
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 0.186761215
            Z: 1.22203422
          }
        }
        ParentId: 2591419040371737519
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
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
            Id: 17609149353171719671
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
        Id: 10959909560365819718
        Name: "Skull"
        Transform {
          Location {
            Y: -16.1610794
            Z: 32.0962639
          }
          Rotation {
          }
          Scale {
            X: 3.98808932
            Y: 3.98808932
            Z: 3.98808932
          }
        }
        ParentId: 2591419040371737519
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 14975829920875445012
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
            Id: 13417453355201377219
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
        Id: 1971586113231562354
        Name: "Position"
        Transform {
          Location {
            X: -23.2817535
            Y: -61.9633293
            Z: 32.8110352
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 6666178998657084514
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsFilePartition: true
          FilePartitionName: "Position"
        }
      }
      Objects {
        Id: 6111999193183961262
        Name: "StartFire"
        Transform {
          Location {
            X: -0.221993327
            Y: -31.5107422
            Z: 67.442627
          }
          Rotation {
          }
          Scale {
          }
        }
        ParentId: 6666178998657084514
        UnregisteredParameters {
          Overrides {
            Name: "cs:DamageAmount"
            Float: 100
          }
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SubObjectId: 9035208620492006363
            }
          }
          Overrides {
            Name: "cs:FireSwitch"
            ObjectReference {
              SubObjectId: 13561333888009855941
            }
          }
          Overrides {
            Name: "cs:FireOnTop"
            Bool: true
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
            Id: 15288972945499590744
          }
        }
      }
      Objects {
        Id: 9035208620492006363
        Name: "Trigger"
        Transform {
          Location {
            X: 7.89608431
            Y: 172.073883
            Z: 92.0861816
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 4.96348906
            Z: 1
          }
        }
        ParentId: 6666178998657084514
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
      }
    }
    Assets {
      Id: 15980367545100223132
      Name: "Whitebox Wall 01 Doorway 01 Frame"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_gen_whitebox_wall_001_doorframe"
      }
    }
    Assets {
      Id: 14975829920875445012
      Name: "Rock Obsidian 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_fresnel_rock_obsidian_001_uv"
      }
    }
    Assets {
      Id: 17609149353171719671
      Name: "Cube - bottom aligned"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_cube_001"
      }
    }
    Assets {
      Id: 13417453355201377219
      Name: "Bone Human Skull 01"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_bones_human_skull_01_ref"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Description: "Flick the switch to change which skull the fire is coming out of. Walk under it or jump over it. "
  }
  SerializationVersion: 65
  DirectlyPublished: true
}
