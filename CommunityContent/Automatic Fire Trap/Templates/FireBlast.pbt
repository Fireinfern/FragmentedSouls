Assets {
  Id: 10126153184180627071
  Name: "FireBlast"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 8055610932964384752
      Objects {
        Id: 8055610932964384752
        Name: "FireBlast"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 14693281810066905981
        ChildIds: 10185861091628234603
        UnregisteredParameters {
          Overrides {
            Name: "cs:Trigger"
            ObjectReference {
              SelfId: 7532466331909987436
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
        Folder {
          IsGroup: true
        }
      }
      Objects {
        Id: 10185861091628234603
        Name: "FireBlast"
        Transform {
          Location {
            X: 39.2616539
            Y: 47.3599548
            Z: 34.6316071
          }
          Scale {
          }
        }
        ParentId: 8055610932964384752
        ChildIds: 12923159918082762416
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
        Id: 12923159918082762416
        Name: "FX"
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
        ParentId: 10185861091628234603
        ChildIds: 13946121374449835074
        ChildIds: 10948671393426219295
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
        Id: 13946121374449835074
        Name: "FX"
        Transform {
          Location {
            X: 5.75656557
            Y: -62.5961876
            Z: 11.6988688
          }
          Rotation {
          }
          Scale {
            X: 0.0999999866
            Y: 0.0999999866
            Z: 0.1
          }
        }
        ParentId: 12923159918082762416
        UnregisteredParameters {
          Overrides {
            Name: "bp:Volume Type"
            Enum {
              Value: "mc:evfxvolumetype:2"
            }
          }
          Overrides {
            Name: "bp:Emissive Boost"
            Float: 24.2483101
          }
          Overrides {
            Name: "bp:Life"
            Float: 2.09991455
          }
          Overrides {
            Name: "bp:Particle Scale Multiplier"
            Float: 0.456106961
          }
          Overrides {
            Name: "bp:Density"
            Float: 10
          }
          Overrides {
            Name: "bp:Gravity"
            Float: 0
          }
          Overrides {
            Name: "bp:Wind Speed"
            Vector {
              Y: 800
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:forceon"
        }
        Blueprint {
          BlueprintAsset {
            Id: 6474768715633236406
          }
          TeamSettings {
          }
          Vfx {
            AutoPlay: true
          }
        }
      }
      Objects {
        Id: 10948671393426219295
        Name: "Fire Torch Ignite Whoosh Quick 01 SFX"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 0.250746638
            Y: 0.250746638
            Z: 0.250746638
          }
        }
        ParentId: 12923159918082762416
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        AudioInstance {
          AudioAsset {
            Id: 12718081095237054033
          }
          AutoPlay: true
          Volume: 1
          Falloff: -1
          Radius: -1
          EnableOcclusion: true
          IsSpatializationEnabled: true
          IsAttenuationEnabled: true
        }
      }
    }
    Assets {
      Id: 6474768715633236406
      Name: "Fire Volume VFX"
      PlatformAssetType: 8
      PrimaryAsset {
        AssetType: "VfxBlueprintAssetRef"
        AssetId: "fxbp_fire_volume_vfx"
      }
    }
    Assets {
      Id: 12718081095237054033
      Name: "Fire Torch Ignite Whoosh Quick 01 SFX"
      PlatformAssetType: 7
      PrimaryAsset {
        AssetType: "AudioAssetRef"
        AssetId: "sfx_fire_torch_ignite_whoosh_quick_01a_Cue_ref"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 65
}
