//
//  Shaders.metal
//  iRetroApp
//
//  Created by Davide Andreoli on 15/05/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertexShader(uint vertexID [[vertex_id]]) {
    float4 positions[4] = {
        float4(-1.0,  1.0, 0.0, 1.0),
        float4(-1.0, -1.0, 0.0, 1.0),
        float4( 1.0,  1.0, 0.0, 1.0),
        float4( 1.0, -1.0, 0.0, 1.0)
    };

    float2 texCoords[4] = {
        float2(0.0, 0.0),
        float2(0.0, 1.0),
        float2(1.0, 0.0),
        float2(1.0, 1.0)
    };

    VertexOut out;
    out.position = positions[vertexID];
    out.texCoord = texCoords[vertexID];
    return out;
}

fragment float4 fragmentShader(VertexOut in [[stage_in]],
                               texture2d<float> texture [[texture(0)]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);

    // Sample texture color
    float4 color = texture.sample(textureSampler, in.texCoord);

    // Apply gamma correction
    //float gamma = 2.2;
    //color.rgb = pow(color.rgb, float3(1.0 / gamma));

    // Adjust exposure
    //float exposure = 1; 
    //color.rgb *= exposure;

    return color;
}





