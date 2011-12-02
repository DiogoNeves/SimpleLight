//
//  Shader.fsh
//  SimpleLight
//
//  Created by Diogo Neves on 02/12/2011.
//  Copyright (c) 2011 Wildbunny Ltd. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
