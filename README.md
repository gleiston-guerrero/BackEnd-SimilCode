# SimilCode Backend

**REST API for source-code similarity analysis and Big O complexity estimation, powered by four commercial large language models used as similarity analysts.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.14](https://img.shields.io/badge/python-3.14-blue.svg)](https://www.python.org/downloads/release/python-3140/)
[![Django 4.2](https://img.shields.io/badge/django-4.2-green.svg)](https://www.djangoproject.com/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21265178.svg)](https://doi.org/10.5281/zenodo.21265178)

---

## Overview

**SimilCode** is a source-code similarity analysis system developed as part of a controlled within-subjects study benchmarking four contemporary commercial large language models (LLMs) as similarity analysts:

- Claude Opus 4.1 (Anthropic)
- GPT-5 (OpenAI)
- Gemini 2.5 Pro (Google)
- DeepSeek-V3 (DeepSeek)

The system returns multidimensional similarity scores together with human-readable justifications, integrated with an automated Big O complexity estimation. It is designed as a **screening aid** for academic-integrity workflows in resource-constrained higher-education institutions, and is explicitly not intended as an evidentiary instrument for adjudicating academic misconduct.

Supported source languages in this release: **C#** and **Java**.

## Related repository

The React 18.2 frontend that consumes this API is available separately:  
[https://github.com/gleiston-guerrero/FrontEnd-SimilCode](https://github.com/gleiston-guerrero/FrontEnd-SimilCode)

## Technical stack

| Component | Version |
|---|---|
| Python | 3.14 |
| Django | 4.2 |
| Django REST Framework | latest |
| PostgreSQL | 15 |
| Docker | 24+ |

## Key components

- **LLM adapter layer** — Standardised request/response handling across the four commercial providers (Anthropic, OpenAI, Google, DeepSeek), each behind an isolated adapter that translates provider-specific payloads to a common internal contract.
- **Standardised prompt template** — Chain-of-Thought (Wei et al., 2022) and Chain-of-Verification (Dhuliawala et al., 2023) scaffolding, reproduced in the accompanying paper (Appendix A).
- **Big O complexity estimation module** — Automated complexity classification for the analysed code pairs.
- **Session and result persistence** — Django ORM over PostgreSQL 15, with schema migrations tracked in `migrations/`.
- **Authentication** — Token-based, integrated with the frontend session model.

## Quick start

### Prerequisites

- Docker 24+ and Docker Compose v2
- API keys for the four LLM providers (set via environment variables; see `.env.example`)

### Installation

```bash
git clone https://github.com/gleiston-guerrero/BackEnd-SimilCode.git
cd BackEnd-SimilCode
cp .env.example .env
# edit .env with your LLM provider API keys and PostgreSQL credentials
docker compose up -d
docker compose exec web python manage.py migrate
docker compose exec web python manage.py createsuperuser
```

The API will be available at `http://localhost:8000/api/`.

### Reproducing the paper's benchmark

The 120 paired code cases used in the accompanying study (60 C# + 60 Java) are archived in Zenodo (DOI to be inserted upon acceptance). To reproduce the benchmark:

```bash
docker compose exec web python manage.py load_benchmark --path /path/to/similcode-benchmark-v1.0/
docker compose exec web python manage.py run_benchmark --models claude,gpt5,gemini,deepseek
```

## Repository structure

```
BackEnd-SimilCode/
├── LICENSE                    # MIT
├── README.md                  # this file
├── CITATION.cff               # machine-readable citation metadata
├── Dockerfile                 # reproducible container build
├── docker-compose.yml         # local orchestration
├── requirements.txt           # locked Python dependencies
├── .env.example               # environment-variable template
├── manage.py                  # Django entry point
├── similcode/                 # Django project settings
├── api/                       # REST endpoints and serialisers
├── llm_adapters/              # provider-specific adapters
│   ├── anthropic.py
│   ├── openai.py
│   ├── google.py
│   └── deepseek.py
├── analysis/                  # similarity and Big O logic
└── migrations/                # database schema history
```

## How to cite

If you use SimilCode in your research, please cite both the software and the accompanying paper:

**Software:**
> Guerrero-Ulloa, G. C., Navas Rivera, R. A., Díaz-Macías, E., Hornos, M. J., & Rodríguez-Domínguez, C. (2026). *SimilCode Backend* (Version 1.0.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.21265178

**Paper:**
> Guerrero-Ulloa, G. C., Navas Rivera, R. A., Díaz-Macías, E., Hornos, M. J., & Rodríguez-Domínguez, C. (2026). SimilCode: A Web Application for Source Code Similarity Detection and Algorithmic Efficiency Analysis using Generative Artificial Intelligence. *International Journal for Educational Integrity* (under review).

A machine-readable `CITATION.cff` file is provided in this repository; GitHub renders a "Cite this repository" button in the sidebar, and Zenodo reads it automatically when minting the DOI.

## Authors and affiliations

| Author | Affiliation | CRediT roles |
|---|---|---|
| **Gleiston Cicerón Guerrero-Ulloa** | Facultad de Ciencias de la Computación, Universidad Técnica Estatal de Quevedo (UTEQ), Ecuador | Conceptualization; Data Curation; Formal Analysis; Methodology; Project Administration; Supervision; Validation; Visualization; Writing – Original Draft; Writing – Review & Editing |
| **Rafael Alexander Navas Rivera** | Facultad de Ciencias de la Computación, Universidad Técnica Estatal de Quevedo (UTEQ), Ecuador | Conceptualization; Data Curation; Formal Analysis; Methodology; Project Administration; Resources; Software; Visualization; Writing – Original Draft; Writing – Review & Editing |
| **Efraín Díaz-Macías** | Facultad de Ciencias de la Computación, Universidad Técnica Estatal de Quevedo (UTEQ), Ecuador | Formal Analysis; Methodology; Project Administration; Resources; Supervision; Validation; Writing – Review & Editing |
| **Miguel J. Hornos** | Department of Software Engineering, University of Granada (UGR), Spain | Formal Analysis; Funding Acquisition; Methodology; Project Administration; Resources; Supervision; Validation; Visualization; Writing – Review & Editing |
| **Carlos Rodríguez-Domínguez** ⭐ | Department of Software Engineering, and Research Center for Information and Communication Technologies (CITIC), University of Granada (UGR), Spain | Formal Analysis; Funding Acquisition; Methodology; Project Administration; Resources; Supervision; Validation; Visualization; Writing – Review & Editing |

⭐ **Corresponding author:** Carlos Rodríguez-Domínguez — <carlosrodriguez@ugr.es>

## Privacy and ethical considerations

Deploying SimilCode routes source code through commercial third-party LLM providers. Institutions adopting the system should establish a formal data-processor relationship consistent with applicable regulations (EU GDPR, Ecuador's *Ley Orgánica de Protección de Datos Personales* — LOPDP, Registro Oficial Suplemento 459, 2021, and equivalent frameworks in other jurisdictions). See Section 5.3 of the accompanying paper for a full discussion.

## Contributing

This repository is the code-of-record for the accompanying peer-reviewed publication. Issues and pull requests are welcome; please open an issue before submitting substantial changes.

## License

MIT License — see [`LICENSE`](LICENSE) for the full text.

## Acknowledgements

The authors thank the five expert instructors of the Faculty of Computer Sciences at the Universidad Técnica Estatal de Quevedo who participated in the validation phase, and acknowledge the institutional support of UTEQ.
