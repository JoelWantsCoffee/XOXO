class Network {
  double[][][] weights;
  double[][] bias;
  double[][] neurons; //values
  int inputNeurons;
  int middleNeurons;
  int outputNeurons;
  int layers;
  
  Network(int inNeurons, int midNeurons, int outNeurons, int layer, float randomize) {
    inputNeurons = inNeurons;
    middleNeurons = midNeurons;
    outputNeurons = outNeurons;
    layers = layer;
    randomize = abs(randomize);
    
    
    weights = new double[layers][][]; //Make the network the right size.
    neurons = new double[layers][];
    bias = new double[layers][];
    weights[0] = new double[middleNeurons][inputNeurons];
    neurons[0] = new double[middleNeurons];
    bias[0] = new double[middleNeurons];
    for (int i = 1; i<(layers-1); i++) {
      weights[i] = new double[middleNeurons][middleNeurons];
      neurons[i] = new double[middleNeurons];
      bias[i] = new double[middleNeurons];
    }
    weights[layers-1] = new double[outputNeurons][middleNeurons];
    neurons[layers-1] = new double[outputNeurons];
    bias[layers-1] = new double[outputNeurons];    
    
    for (int i = 0; i<layers; i++) for (int j = 0; j<bias[i].length; j++) bias[i][j] =random(-randomize, randomize);
    
    //randomise Weights
    for (int i = 0; i<layers; i++) {
      //first layer
      if (i == 0) {
        for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<inputNeurons; k++) weights[i][j][k] = random(-randomize, randomize);
      } else {
      //middle layers
        if (i<layers-1) {
          for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<middleNeurons; k++) weights[i][j][k] = random(-randomize, randomize);
          //last layer
        } else for (int j = 0; j<outputNeurons; j++) for (int k = 0; k<middleNeurons; k++) weights[i][j][k] = random(-randomize, randomize);
      }
    }
    
  }
  
  double[] think(double inputs[]) {
    double[] outPuts = new double[outputNeurons];
    //first Layer
    for (int i = 0; i<middleNeurons; i++) {
      neurons[0][i] = bias[0][i];
      for (int j = 0; j<inputNeurons;j++) neurons[0][i] += weights[0][i][j]*inputs[j];
      neurons[0][i] = sigmoid(neurons[0][i]);
    }
    
    //middle Layers;
    for (int k = 1; k<layers-1; k++) {
      for (int i = 0; i<middleNeurons; i++) {
        neurons[k][i] = bias[k][i];
        for (int j = 0; j<middleNeurons;j++) neurons[k][i] += weights[k][i][j]*neurons[k-1][j];
        neurons[k][i] = sigmoid(neurons[k][i]);
      }
    }

    //outPut Layers;
    for (int i = 0; i<outputNeurons; i++) {
      neurons[layers-1][i] = bias[layers-1][i];
      for (int j = 0; j<middleNeurons;j++) neurons[layers-1][i] += weights[layers-1][i][j]*neurons[layers-2][j];
      neurons[layers-1][i] = sigmoid(neurons[layers-1][i]);
    }
    
    outPuts = neurons[layers-1];
    
    return outPuts;
  }
  
  void learn(double[] inputs, double[] desiredOutputs, float stepSize) {
    double[][] error = new double[neurons.length][];
    double[] played = think(inputs);
    
    for (int i = 0; i<error.length; i++) {
      error[i] = new double[neurons[i].length];
      for (int j = 0; j<error[i].length; j++) error[i][j] = (double) 0;
    }
    
    for (int i = 0; i<outputNeurons; i++) error[layers-1][i]=(played[i] - desiredOutputs[i])*dsigmoid(neurons[layers-1][i]);
    
    //println(error[layers-1][0]);
    
    for (int i = layers-2; i>0; i--) {
      for (int j = 0; j< middleNeurons; j++) {
        double sum = 0;
        for (int k = 0; k< error[i+1].length; k++) {
          sum += weights[i+1][k][j] * error[i+1][k];
        }
        error[i][j] = sum*dsigmoid(neurons[i][j]);
      }
    }
    
    //tweak weights
    for (int i = 1; i<layers; i++) {
      for (int j = 0; j<neurons[i].length; j++) {
        for (int pj = 0; pj<neurons[i-1].length; pj++) {
          double delta = -stepSize * neurons[i-1][pj] * error[i][j];
          weights[i][j][pj] += delta;
        }
        bias[i][j] += stepSize * error[i][j];
      }
    }
    
  }
  
  void export(String file) {
    PrintWriter net;
    net = createWriter(file);
    String[] brain = new String[layers];
    for (int i = 0; i<layers; i++) {
      brain[i] = "";
      //first layer
      if (i == 0) {
        for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<inputNeurons; k++) brain[i] = brain[i] + weights[i][j][k] + ", ";
      } else {
      //middle layers
        if (i<layers-1) {
          for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<middleNeurons; k++) brain[i] = brain[i] + weights[i][j][k] + ", ";
          //last layer
        } else for (int j = 0; j<outputNeurons; j++) for (int k = 0; k<middleNeurons; k++) brain[i] = brain[i] + weights[i][j][k] + ", ";
      }
      net.println(brain[i]);
    }
    net.flush();
    net.close();
  }
  
  void importNet(String file) {
    String[] whole = loadStrings(file);
    for (int i = 0; i<layers; i++) {
      String[] layer = split(whole[i], ", ");
      //first layer
      if (i == 0) {
        for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<inputNeurons; k++) weights[i][j][k] = (double) float(layer[j*inputNeurons + k]);
      } else {
      //middle layers
        if (i<layers-1) {
          for (int j = 0; j<middleNeurons; j++) for (int k = 0; k<middleNeurons; k++) weights[i][j][k] = (double) float(layer[j*middleNeurons + k]);
          //last layer
        } else {
          for (int j = 0; j<outputNeurons; j++) for (int k = 0; k<middleNeurons; k++) weights[i][j][k] = (double) float(layer[j*middleNeurons + k]);
        }
      }
    }
  }
  
}

double sigmoid(double input) { return (float(1) / (float(1) + Math.pow(2.71828182846, -input))); }
//double dsigmoid(double input) { return (sigmoid(input)*(1-sigmoid(input))); }
double dsigmoid(double input) { return (input*(1-input)); }
