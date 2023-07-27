import React from 'react';

import { Status } from '../models';
import { Error, Loader, NutriscoreBar } from '../components';
import { Card } from 'react-bootstrap';
import { API_URL } from '../config';

interface AiNutritionAnalysisProps {
}

interface AiNutritionAnalysisState {
  nutriscore: string;
  explanation: string;
  recommendation: string;
  status: Status;
  errorMessage?: string;
}

export class AiNutritionAnalysis extends React.Component<AiNutritionAnalysisProps, AiNutritionAnalysisState> {
  state: AiNutritionAnalysisState = {
    nutriscore: '',
    explanation: '',
    recommendation: '',
    status: Status.LOADING,
  };

  componentDidMount(): void {
    fetch(`${API_URL}/api/cart-items/ai-nutrition-analysis`)
      .then((response) => response.json())
      .then((data) => this.setState({
        nutriscore: data.nutriscore,
        explanation: data.explanation,
        recommendation: data.recommendation,
        status: Status.LOADED
      }))
      .catch((error) => this.setState({
        nutriscore: '',
        explanation: '',
        recommendation: '',
        status: Status.ERROR,
        errorMessage: error.message,
      }));
  }

  getHtmlForRecommendation(): JSX.Element {
    return (
      <>
      <NutriscoreBar nutriscore={this.state.nutriscore} />
      <Card.Text>{this.state.explanation}</Card.Text>
      <Card.Text>{this.state.recommendation}</Card.Text>
      </>
    );
  }

  render() {
    const { status } = this.state;
    return (
      <Card className='mb-3'>
        <Card.Body>
          <Card.Title>AI Nutrition Analysis</Card.Title>
          {status === Status.LOADING && <Loader />}
          {status === Status.ERROR && <Error errorMessage={this.state.errorMessage} />}
          {status === Status.LOADED && this.getHtmlForRecommendation()}
        </Card.Body>
      </Card>
    );
  }
}